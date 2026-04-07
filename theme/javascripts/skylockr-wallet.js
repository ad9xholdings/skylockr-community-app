// SkyLockr XRP Wallet Connector
// Integrates XUMM wallet for XRP Ledger authentication

import { apiInitializer } from "discourse/lib/api";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";
import { withPluginApi } from "discourse/lib/plugin-api";

export default apiInitializer("1.0", (api) => {
  // XRP Wallet state
  let walletState = {
    connected: false,
    address: null,
    balance: null,
    network: 'mainnet',
    membershipTier: null
  };

  // Initialize XRP Wallet Widget
  api.decorateWidget("header-icons:after", (helper) => {
    return helper.h("div.xrp-wallet-header-btn", [
      helper.h("button.wallet-connect-btn", {
        onclick: () => toggleWalletWidget()
      }, walletState.connected ? "💳" : "🔗 Connect Wallet")
    ]);
  });

  // Add XRP Wallet Widget to sidebar
  api.decorateWidget("sidebar-topics:after", (helper) => {
    return helper.h("div.xrp-wallet-widget", [
      helper.h("div.widget-header", [
        helper.h("span.widget-icon", "💎"),
        helper.h("h4", "XRP Wallet")
      ]),
      helper.h("div.wallet-status", {
        className: walletState.connected ? "connected" : ""
      }, walletState.connected ? renderConnectedWallet() : renderConnectButton())
    ]);
  });

  // Membership Tier Badge on user cards
  api.decorateWidget("user-card-contents:after", (helper) => {
    const user = helper.getModel();
    const tier = user.skylockr_membership_tier || 'entry';
    
    return helper.h("div.membership-badge", {
      className: tier,
      title: `SkyLockr ${tier.charAt(0).toUpperCase() + tier.slice(1)} Member`
    }, [
      helper.h("span.tier-icon", getTierIcon(tier)),
      helper.h("span.tier-label", tier.toUpperCase())
    ]);
  });

  // Add XRP wallet info to user profile
  api.decorateWidget("user-profile-controls:after", (helper) => {
    const user = helper.getModel();
    
    if (user.xrp_wallet_address) {
      return helper.h("div.xrp-wallet-info", [
        helper.h("div.wallet-label", "XRP Wallet"),
        helper.h("div.wallet-address", truncateAddress(user.xrp_wallet_address)),
        user.xrp_wallet_verified ? helper.h("span.wallet-verified", "Verified") : null
      ]);
    }
  });

  // Initialize XUMM SDK
  function initXumm() {
    if (typeof XummSdk !== 'undefined') {
      return new XummSdk(settings.xumm_api_key);
    }
    // Load XUMM SDK dynamically
    return loadScript("https://xumm.app/assets/cdn/xumm-sdk.js").then(() => {
      return new XummSdk(settings.xumm_api_key);
    });
  }

  // Connect wallet via XUMM
  async function connectWallet() {
    try {
      const xumm = await initXumm();
      
      // Create sign-in payload
      const payload = await xumm.payload.create({
        txjson: {
          TransactionType: "SignIn"
        },
        options: {
          submit: false,
          expire: 5,
          return_url: {
            app: window.location.origin + "/wallet/callback",
            web: window.location.origin + "/wallet/callback"
          }
        }
      });

      // Open XUMM app
      window.open(`https://xumm.app/sign/${payload.uuid}`, '_blank');

      // Poll for completion
      pollWalletConnection(payload.uuid);
    } catch (error) {
      console.error("XUMM connection failed:", error);
      popupAjaxError(error);
    }
  }

  // Poll for wallet connection
  async function pollWalletConnection(uuid) {
    const checkInterval = setInterval(async () => {
      try {
        const response = await ajax(`/xrp-wallet/verify/${uuid}`);
        
        if (response.verified) {
          clearInterval(checkInterval);
          walletState = {
            connected: true,
            address: response.address,
            balance: response.balance,
            network: response.network,
            membershipTier: response.membership_tier
          };
          
          // Update UI
          api.redraw();
          
          // Show success notification
          api.addNotice("Wallet connected successfully!", {
            type: "success",
            timeout: 3000
          });
        }
      } catch (error) {
        console.error("Verification poll failed:", error);
      }
    }, 3000);

    // Stop polling after 5 minutes
    setTimeout(() => clearInterval(checkInterval), 300000);
  }

  // Disconnect wallet
  async function disconnectWallet() {
    try {
      await ajax("/xrp-wallet/disconnect", { type: "POST" });
      walletState = {
        connected: false,
        address: null,
        balance: null,
        network: 'mainnet',
        membershipTier: null
      };
      api.redraw();
    } catch (error) {
      popupAjaxError(error);
    }
  }

  // Render connected wallet UI
  function renderConnectedWallet() {
    return [
      h("div.wallet-address", truncateAddress(walletState.address)),
      h("div.wallet-balance", `${walletState.balance} XRP`),
      h("button.disconnect-btn", {
        onclick: disconnectWallet
      }, "Disconnect")
    ];
  }

  // Render connect button
  function renderConnectButton() {
    return h("button.connect-btn", {
      onclick: connectWallet
    }, "Connect XUMM Wallet");
  }

  // Helper functions
  function getTierIcon(tier) {
    const icons = {
      entry: "🌱",
      pro: "⚡",
      master: "👑",
      prime: "💎"
    };
    return icons[tier] || "🌱";
  }

  function truncateAddress(address) {
    if (!address) return "";
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  }

  function toggleWalletWidget() {
    const widget = document.querySelector(".xrp-wallet-widget");
    if (widget) {
      widget.classList.toggle("expanded");
    }
  }

  // Membership tier verification
  api.addPostMenuButton("membership-verify", (attrs) => {
    return {
      action: "verifyMembership",
      icon: "certificate",
      className: "membership-verify-btn",
      title: "Verify Membership Tier",
      position: "first"
    };
  });

  api.attachWidgetAction("post-menu", "verifyMembership", function() {
    const post = this.findAncestorModel();
    
    ajax("/skylockr/verify-membership", {
      type: "POST",
      data: { user_id: post.user_id }
    }).then((result) => {
      bootbox.alert(`Membership verified: ${result.tier.toUpperCase()}`);
    }).catch(popupAjaxError);
  });

  // JamZia SSO integration
  api.onPageChange(() => {
    const params = new URLSearchParams(window.location.search);
    const jamziaToken = params.get("jamzia_token");
    
    if (jamziaToken) {
      // Verify JamZia token
      ajax("/auth/jamzia/callback", {
        type: "POST",
        data: { token: jamziaToken }
      }).then((result) => {
        // Clear token from URL
        window.history.replaceState({}, document.title, window.location.pathname);
        
        if (result.success) {
          api.addNotice("Successfully logged in via JamZia!", {
            type: "success"
          });
        }
      }).catch((error) => {
        console.error("JamZia SSO failed:", error);
        api.addNotice("JamZia login failed. Please try again.", {
          type: "error"
        });
      });
    }
  });
});
