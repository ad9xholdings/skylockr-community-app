const { contextBridge, ipcRenderer } = require('electron');

// Expose secure APIs to renderer process
contextBridge.exposeInMainWorld('electronAPI', {
  // App info
  getVersion: () => ipcRenderer.invoke('get-app-version'),
  
  // Secure storage
  store: {
    get: (key) => ipcRenderer.invoke('get-store-value', key),
    set: (key, value) => ipcRenderer.invoke('set-store-value', key, value),
    delete: (key) => ipcRenderer.invoke('delete-store-value', key)
  },
  
  // Notifications
  showNotification: (title, body) => {
    new Notification(title, { body });
  }
});

// SkyLockr Wallet Bridge
contextBridge.exposeInMainWorld('SkyLockrWallet', {
  async connect() {
    // Trigger wallet connection in the web app
    window.postMessage({ type: 'XRP_WALLET_CONNECT' }, '*');
  },
  
  async disconnect() {
    await window.electronAPI.store.delete('xrp_wallet');
    window.postMessage({ type: 'XRP_WALLET_DISCONNECT' }, '*');
  },
  
  async isConnected() {
    const wallet = await window.electronAPI.store.get('xrp_wallet');
    return wallet !== undefined;
  },
  
  async getAddress() {
    return await window.electronAPI.store.get('xrp_wallet_address');
  },
  
  async getNetwork() {
    return await window.electronAPI.store.get('xrp_network') || 'mainnet';
  }
});

// Handle messages from main process
ipcRenderer.on('deep-link', (event, url) => {
  window.postMessage({ type: 'DEEP_LINK', url }, '*');
});

// Listen for XUMM callbacks
window.handleXummCallback = async (uuid) => {
  try {
    const response = await fetch(`/xrp-wallet/verify/${uuid}`);
    const data = await response.json();
    
    if (data.verified) {
      await window.electronAPI.store.set('xrp_wallet', 'connected');
      await window.electronAPI.store.set('xrp_wallet_address', data.address);
      await window.electronAPI.store.set('xrp_network', data.network);
      
      // Show notification
      new Notification('SkyLockr', {
        body: 'XRP Wallet connected successfully!'
      });
      
      // Reload page
      window.location.reload();
    }
  } catch (error) {
    console.error('XUMM callback failed:', error);
  }
};

// Listen for JamZia callbacks
window.handleJamziaCallback = async (token) => {
  try {
    const response = await fetch('/auth/jamzia/callback', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ token })
    });
    
    const data = await response.json();
    
    if (data.success) {
      new Notification('SkyLockr', {
        body: 'Successfully logged in via JamZia!'
      });
      window.location.href = '/';
    }
  } catch (error) {
    console.error('JamZia callback failed:', error);
  }
};
