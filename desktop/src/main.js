const { app, BrowserWindow, ipcMain, shell, Tray, Menu, nativeImage } = require('electron');
const path = require('path');
const log = require('electron-log');
const Store = require('electron-store');
const windowStateKeeper = require('electron-window-state');
const { autoUpdater } = require('electron-updater');

// Initialize logging
log.info('SkyLockr Community Desktop starting...');

// Initialize secure store
const store = new Store({
  encryptionKey: 'skylockr-community-secure-storage-key-2026'
});

// App configuration
const CONFIG = {
  appName: 'SkyLockr Community',
  webAppUrl: 'https://community.skylockr.com',
  localDevUrl: 'http://localhost:80',
  iconPath: path.join(__dirname, '../assets/icon.png'),
  trayIconPath: path.join(__dirname, '../assets/tray-icon.png')
};

let mainWindow;
let tray;
let isQuitting = false;

// Create main window
function createWindow() {
  // Load previous window state
  const mainWindowState = windowStateKeeper({
    defaultWidth: 1400,
    defaultHeight: 900,
    maximize: true
  });

  // Create browser window
  mainWindow = new BrowserWindow({
    x: mainWindowState.x,
    y: mainWindowState.y,
    width: mainWindowState.width,
    height: mainWindowState.height,
    minWidth: 1000,
    minHeight: 700,
    title: CONFIG.appName,
    icon: CONFIG.iconPath,
    show: false, // Show when ready
    titleBarStyle: process.platform === 'darwin' ? 'hiddenInset' : 'default',
    backgroundColor: '#002145',
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      enableRemoteModule: false,
      preload: path.join(__dirname, 'preload.js'),
      spellcheck: true
    }
  });

  // Track window state
  mainWindowState.manage(mainWindow);

  // Load app
  const startUrl = process.env.NODE_ENV === 'development' 
    ? CONFIG.localDevUrl 
    : CONFIG.webAppUrl;
  
  mainWindow.loadURL(startUrl);

  // Show window when ready
  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
    
    if (mainWindowState.isMaximized) {
      mainWindow.maximize();
    }

    // Check for updates in production
    if (process.env.NODE_ENV !== 'development') {
      autoUpdater.checkForUpdatesAndNotify();
    }
  });

  // Handle window close
  mainWindow.on('close', (event) => {
    if (!isQuitting && process.platform === 'darwin') {
      event.preventDefault();
      mainWindow.hide();
    }
  });

  // Handle window closed
  mainWindow.on('closed', () => {
    mainWindow = null;
  });

  // Handle new window requests (open in browser)
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  // Handle navigation
  mainWindow.webContents.on('will-navigate', (event, url) => {
    // Allow internal navigation
    if (url.startsWith(CONFIG.webAppUrl) || url.startsWith(CONFIG.localDevUrl)) {
      return;
    }
    
    // Open external links in browser
    event.preventDefault();
    shell.openExternal(url);
  });
}

// Create system tray
function createTray() {
  const trayIcon = nativeImage.createFromPath(CONFIG.trayIconPath);
  tray = new Tray(trayIcon.resize({ width: 16, height: 16 }));
  
  const contextMenu = Menu.buildFromTemplate([
    {
      label: 'Open SkyLockr',
      click: () => {
        if (mainWindow) {
          mainWindow.show();
          mainWindow.focus();
        } else {
          createWindow();
        }
      }
    },
    { type: 'separator' },
    {
      label: 'Wallet',
      submenu: [
        {
          label: 'Connect XUMM',
          click: () => {
            mainWindow?.webContents.executeJavaScript(`
              window.SkyLockrWallet?.connect();
            `);
          }
        },
        {
          label: 'View Balance',
          click: () => {
            mainWindow?.webContents.executeJavaScript(`
              window.location.href = '/u/me/preferences/wallet';
            `);
            mainWindow?.show();
          }
        }
      ]
    },
    { type: 'separator' },
    {
      label: 'Membership',
      submenu: [
        { label: 'Entry', type: 'radio', checked: true },
        { label: 'Pro', type: 'radio' },
        { label: 'Master', type: 'radio' },
        { label: 'Prime', type: 'radio' }
      ]
    },
    { type: 'separator' },
    {
      label: 'Notifications',
      submenu: [
        { label: 'Enable', type: 'checkbox', checked: true },
        { label: 'Do Not Disturb', type: 'checkbox' }
      ]
    },
    { type: 'separator' },
    {
      label: 'Settings',
      click: () => {
        mainWindow?.webContents.executeJavaScript(`
          window.location.href = '/u/me/preferences';
        `);
        mainWindow?.show();
      }
    },
    { type: 'separator' },
    {
      label: 'Quit',
      click: () => {
        isQuitting = true;
        app.quit();
      }
    }
  ]);

  tray.setToolTip(CONFIG.appName);
  tray.setContextMenu(contextMenu);
  
  tray.on('click', () => {
    if (mainWindow) {
      mainWindow.isVisible() ? mainWindow.hide() : mainWindow.show();
    } else {
      createWindow();
    }
  });
}

// App event handlers
app.whenReady().then(() => {
  createWindow();
  createTray();

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    } else {
      mainWindow?.show();
    }
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('before-quit', () => {
  isQuitting = true;
});

// IPC handlers
ipcMain.handle('get-app-version', () => {
  return app.getVersion();
});

ipcMain.handle('get-store-value', (event, key) => {
  return store.get(key);
});

ipcMain.handle('set-store-value', (event, key, value) => {
  store.set(key, value);
});

ipcMain.handle('delete-store-value', (event, key) => {
  store.delete(key);
});

// Deep link handling (XUMM callback)
app.setAsDefaultProtocolClient('skylockr');

app.on('open-url', (event, url) => {
  event.preventDefault();
  handleDeepLink(url);
});

// Windows/Linux deep link
if (process.platform === 'win32' || process.platform === 'linux') {
  const gotTheLock = app.requestSingleInstanceLock();
  
  if (!gotTheLock) {
    app.quit();
  } else {
    app.on('second-instance', (event, commandLine) => {
      const url = commandLine.find(arg => arg.startsWith('skylockr://'));
      if (url) {
        handleDeepLink(url);
      }
      
      if (mainWindow) {
        if (mainWindow.isMinimized()) mainWindow.restore();
        mainWindow.show();
        mainWindow.focus();
      }
    });
  }
}

function handleDeepLink(url) {
  const urlObj = new URL(url);
  
  if (urlObj.hostname === 'wallet' && urlObj.pathname === '/callback') {
    const uuid = urlObj.searchParams.get('uuid');
    if (uuid && mainWindow) {
      mainWindow.webContents.executeJavaScript(`
        window.handleXummCallback?.('${uuid}');
      `);
    }
  }
  
  if (urlObj.hostname === 'auth' && urlObj.pathname === '/jamzia') {
    const token = urlObj.searchParams.get('token');
    if (token && mainWindow) {
      mainWindow.webContents.executeJavaScript(`
        window.handleJamziaCallback?.('${token}');
      `);
    }
  }
  
  mainWindow?.show();
}

// Auto updater events
autoUpdater.on('checking-for-update', () => {
  log.info('Checking for update...');
});

autoUpdater.on('update-available', (info) => {
  log.info('Update available:', info);
});

autoUpdater.on('update-not-available', (info) => {
  log.info('Update not available:', info);
});

autoUpdater.on('error', (err) => {
  log.error('Error in auto-updater:', err);
});

autoUpdater.on('download-progress', (progressObj) => {
  log.info(`Download progress: ${progressObj.percent}%`);
});

autoUpdater.on('update-downloaded', (info) => {
  log.info('Update downloaded:', info);
  // Notify user and install on next restart
  autoUpdater.quitAndInstall();
});
