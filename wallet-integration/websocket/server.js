const WebSocket = require('ws');
const Redis = require('ioredis');
const jwt = require('jsonwebtoken');
const express = require('express');
const cors = require('cors');
const winston = require('winston');

// Logger configuration
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console()
  ]
});

// Configuration
const CONFIG = {
  port: process.env.PORT || 8080,
  xrpNetwork: process.env.XRP_NETWORK || 'mainnet',
  xrpWsUrl: process.env.XRP_WS_URL || 'wss://s1.ripple.com',
  redisUrl: process.env.REDIS_URL || 'redis://redis:6379/1',
  jwtSecret: process.env.JWT_SECRET || 'your-secret-key'
};

// Initialize Redis
const redis = new Redis(CONFIG.redisUrl);

// XRP Ledger WebSocket connection
let xrpConnection = null;
let reconnectAttempts = 0;
const MAX_RECONNECT_ATTEMPTS = 10;

// Connected clients
const clients = new Map();

// Connect to XRP Ledger
function connectToXRP() {
  if (xrpConnection) return;
  
  logger.info(`Connecting to XRP Ledger: ${CONFIG.xrpWsUrl}`);
  
  xrpConnection = new WebSocket(CONFIG.xrpWsUrl);
  
  xrpConnection.on('open', () => {
    logger.info('Connected to XRP Ledger');
    reconnectAttempts = 0;
    
    // Resubscribe all clients
    clients.forEach((client, clientId) => {
      if (client.subscribedAccount) {
        subscribeToAccount(client.subscribedAccount);
      }
    });
  });
  
  xrpConnection.on('message', (data) => {
    try {
      const message = JSON.parse(data);
      handleXRPLMessage(message);
    } catch (error) {
      logger.error('Failed to parse XRP message:', error);
    }
  });
  
  xrpConnection.on('close', () => {
    logger.warn('XRP Ledger connection closed');
    xrpConnection = null;
    
    if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
      reconnectAttempts++;
      const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
      logger.info(`Reconnecting in ${delay}ms (attempt ${reconnectAttempts})`);
      setTimeout(connectToXRP, delay);
    }
  });
  
  xrpConnection.on('error', (error) => {
    logger.error('XRP Ledger connection error:', error);
  });
}

// Subscribe to account transactions
function subscribeToAccount(address) {
  if (!xrpConnection || xrpConnection.readyState !== WebSocket.OPEN) return;
  
  const subscribeMsg = {
    command: 'subscribe',
    accounts: [address]
  };
  
  xrpConnection.send(JSON.stringify(subscribeMsg));
  logger.info(`Subscribed to account: ${address}`);
}

// Unsubscribe from account
function unsubscribeFromAccount(address) {
  if (!xrpConnection || xrpConnection.readyState !== WebSocket.OPEN) return;
  
  const unsubscribeMsg = {
    command: 'unsubscribe',
    accounts: [address]
  };
  
  xrpConnection.send(JSON.stringify(unsubscribeMsg));
}

// Handle XRP Ledger messages
function handleXRPLMessage(message) {
  // Forward to relevant clients
  if (message.transaction && message.transaction.Account) {
    const account = message.transaction.Account;
    
    clients.forEach((client, clientId) => {
      if (client.subscribedAccount === account && client.ws.readyState === WebSocket.OPEN) {
        client.ws.send(JSON.stringify({
          type: 'transaction',
          data: message
        }));
      }
    });
    
    // Cache in Redis
    redis.publish(`xrp:account:${account}`, JSON.stringify(message));
  }
  
  // Handle ledger close
  if (message.type === 'ledgerClosed') {
    clients.forEach((client, clientId) => {
      if (client.ws.readyState === WebSocket.OPEN) {
        client.ws.send(JSON.stringify({
          type: 'ledger',
          data: message
        }));
      }
    });
  }
}

// Start WebSocket server
function startWebSocketServer() {
  const wss = new WebSocket.Server({ noServer: true });
  
  wss.on('connection', (ws, req) => {
    const clientId = `${req.socket.remoteAddress}:${Date.now()}`;
    
    logger.info(`Client connected: ${clientId}`);
    
    clients.set(clientId, {
      ws,
      subscribedAccount: null,
      authenticated: false
    });
    
    ws.on('message', async (data) => {
      try {
        const message = JSON.parse(data);
        await handleClientMessage(clientId, message);
      } catch (error) {
        logger.error('Failed to handle client message:', error);
        ws.send(JSON.stringify({ error: 'Invalid message' }));
      }
    });
    
    ws.on('close', () => {
      logger.info(`Client disconnected: ${clientId}`);
      const client = clients.get(clientId);
      if (client && client.subscribedAccount) {
        unsubscribeFromAccount(client.subscribedAccount);
      }
      clients.delete(clientId);
    });
    
    // Send welcome message
    ws.send(JSON.stringify({
      type: 'connected',
      network: CONFIG.xrpNetwork,
      timestamp: Date.now()
    }));
  });
  
  return wss;
}

// Handle client messages
async function handleClientMessage(clientId, message) {
  const client = clients.get(clientId);
  if (!client) return;
  
  switch (message.type) {
    case 'auth':
      // Verify JWT token
      try {
        const decoded = jwt.verify(message.token, CONFIG.jwtSecret);
        client.authenticated = true;
        client.userId = decoded.userId;
        client.ws.send(JSON.stringify({ type: 'auth', status: 'success' }));
      } catch (error) {
        client.ws.send(JSON.stringify({ type: 'auth', status: 'failed' }));
      }
      break;
      
    case 'subscribe':
      if (!client.authenticated) {
        client.ws.send(JSON.stringify({ error: 'Not authenticated' }));
        return;
      }
      
      if (message.account) {
        client.subscribedAccount = message.account;
        subscribeToAccount(message.account);
        client.ws.send(JSON.stringify({ 
          type: 'subscribed', 
          account: message.account 
        }));
      }
      break;
      
    case 'unsubscribe':
      if (client.subscribedAccount) {
        unsubscribeFromAccount(client.subscribedAccount);
        client.subscribedAccount = null;
      }
      break;
      
    case 'ping':
      client.ws.send(JSON.stringify({ type: 'pong', timestamp: Date.now() }));
      break;
      
    default:
      client.ws.send(JSON.stringify({ error: 'Unknown message type' }));
  }
}

// Start HTTP server
const app = express();
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    xrpConnected: xrpConnection && xrpConnection.readyState === WebSocket.OPEN,
    clients: clients.size,
    timestamp: new Date().toISOString()
  });
});

// Start server
const server = app.listen(CONFIG.port, () => {
  logger.info(`XRP WebSocket service listening on port ${CONFIG.port}`);
});

// Upgrade HTTP to WebSocket
const wss = startWebSocketServer();

server.on('upgrade', (request, socket, head) => {
  wss.handleUpgrade(request, socket, head, (ws) => {
    wss.emit('connection', ws, request);
  });
});

// Connect to XRP Ledger
connectToXRP();

// Graceful shutdown
process.on('SIGTERM', () => {
  logger.info('SIGTERM received, shutting down...');
  server.close(() => {
    logger.info('Server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  logger.info('SIGINT received, shutting down...');
  server.close(() => {
    logger.info('Server closed');
    process.exit(0);
  });
});
