// SkyLockr Mobile App - Main JavaScript Bridge
// Handles native app functionality and XUMM wallet integration

document.addEventListener('DOMContentLoaded', async () => {
  // Initialize Capacitor plugins
  const { App } = await import('@capacitor/app');
  const { SplashScreen } = await import('@capacitor/splash-screen');
  const { StatusBar } = await import('@capacitor/status-bar');
  const { Preferences } = await import('@capacitor/preferences');
  const { Browser } = await import('@capacitor/browser');
  const { PushNotifications } = await import('@capacitor/push-notifications');
  
  // Set SkyLockr brand colors
  await StatusBar.setBackgroundColor({ color: '#002145' });
  await StatusBar.setStyle({ style: 'Dark' });
  
  // Hide splash screen after load
  setTimeout(() => {
    SplashScreen.hide();
  }, 2000);
  
  // Handle deep links
  App.addListener('appUrlOpen', async (data) => {
    const url = new URL(data.url);
    
    // Handle XUMM callback
    if (url.pathname === '/wallet/callback') {
      const uuid = url.searchParams.get('xumm_uuid');
      if (uuid) {
        await handleXummCallback(uuid);
      }
    }
    
    // Handle JamZia SSO
    if (url.pathname === '/auth/jamzia/callback') {
      const token = url.searchParams.get('token');
      if (token) {
        await handleJamziaCallback(token);
      }
    }
  });
  
  // Initialize push notifications
  await initPushNotifications();
  
  // XUMM Wallet Bridge for Mobile
  window.SkyLockrWallet = {
    async connect() {
      try {
        // Check if XUMM app is installed
        const canOpen = await Browser.canOpenUrl({ url: 'xumm://' });
        
        if (canOpen.value) {
          // Open XUMM app directly
          await Browser.open({ url: 'xumm://request/signin' });
        } else {
          // Fall back to web flow
          await Browser.open({ 
            url: 'https://xumm.app/detect/app',
            presentationStyle: 'popover'
          });
        }
      } catch (error) {
        console.error('Wallet connection failed:', error);
      }
    },
    
    async disconnect() {
      await Preferences.remove({ key: 'xrp_wallet' });
      window.location.reload();
    },
    
    async isConnected() {
      const { value } = await Preferences.get({ key: 'xrp_wallet' });
      return value !== null;
    },
    
    async getAddress() {
      const { value } = await Preferences.get({ key: 'xrp_wallet_address' });
      return value;
    }
  };
  
  // Mobile-optimized UI enhancements
  enhanceMobileUI();
});

// Handle XUMM callback
async function handleXummCallback(uuid) {
  try {
    const response = await fetch(`/xrp-wallet/verify/${uuid}`);
    const data = await response.json();
    
    if (data.verified) {
      const { Preferences } = await import('@capacitor/preferences');
      await Preferences.set({ key: 'xrp_wallet', value: 'connected' });
      await Preferences.set({ key: 'xrp_wallet_address', value: data.address });
      
      // Show success notification
      const { Toast } = await import('@capacitor/toast');
      await Toast.show({
        text: 'Wallet connected successfully!',
        duration: 'long'
      });
      
      // Refresh UI
      window.location.reload();
    }
  } catch (error) {
    console.error('XUMM callback failed:', error);
  }
}

// Handle JamZia SSO callback
async function handleJamziaCallback(token) {
  try {
    const response = await fetch('/auth/jamzia/callback', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ token })
    });
    
    const data = await response.json();
    
    if (data.success) {
      const { Toast } = await import('@capacitor/toast');
      await Toast.show({
        text: 'Logged in via JamZia!',
        duration: 'long'
      });
      
      window.location.href = '/';
    }
  } catch (error) {
    console.error('JamZia callback failed:', error);
  }
}

// Initialize push notifications
async function initPushNotifications() {
  const { PushNotifications } = await import('@capacitor/push-notifications');
  
  // Request permission
  const permission = await PushNotifications.requestPermissions();
  
  if (permission.receive === 'granted') {
    await PushNotifications.register();
    
    // Listen for notifications
    PushNotifications.addListener('pushNotificationReceived', (notification) => {
      console.log('Push received:', notification);
    });
    
    PushNotifications.addListener('pushNotificationActionPerformed', (action) => {
      console.log('Push action:', action);
      // Navigate to relevant content
      if (action.notification.data?.topic_id) {
        window.location.href = `/t/${action.notification.data.topic_id}`;
      }
    });
  }
}

// Mobile UI enhancements
function enhanceMobileUI() {
  // Add pull-to-refresh
  let touchStartY = 0;
  let touchEndY = 0;
  
  document.addEventListener('touchstart', (e) => {
    touchStartY = e.changedTouches[0].screenY;
  }, { passive: true });
  
  document.addEventListener('touchend', async (e) => {
    touchEndY = e.changedTouches[0].screenY;
    
    // Pull to refresh when at top of page
    if (touchEndY > touchStartY + 150 && window.scrollY === 0) {
      const { Haptics } = await import('@capacitor/haptics');
      await Haptics.impact({ style: 'light' });
      window.location.reload();
    }
  }, { passive: true });
  
  // Hide/show header on scroll
  let lastScrollY = window.scrollY;
  const header = document.querySelector('.d-header');
  
  window.addEventListener('scroll', () => {
    if (window.scrollY > lastScrollY && window.scrollY > 100) {
      header?.classList.add('header-hidden');
    } else {
      header?.classList.remove('header-hidden');
    }
    lastScrollY = window.scrollY;
  }, { passive: true });
}
