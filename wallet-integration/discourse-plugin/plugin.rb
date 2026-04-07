// XRP Wallet Integration Plugin for Discourse
// Server-side Ruby plugin

# frozen_string_literal: true

module ::SkylockrXrpWallet
  PLUGIN_NAME = "skylockr-xrp-wallet"
  
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace SkylockrXrpWallet
  end
end

require_relative "lib/xrp_wallet/engine"
require_relative "lib/xrp_wallet/xumm_client"
require_relative "lib/xrp_wallet/xrpl_client"

# Register plugin
discourse_config = Discourse::Application.config

after_initialize do
  # Add custom user fields for XRP wallet
  User.register_custom_field_type("xrp_wallet_address", :string)
  User.register_custom_field_type("xrp_wallet_verified", :boolean)
  User.register_custom_field_type("xrp_wallet_network", :string)
  User.register_custom_field_type("skylockr_membership_tier", :string)
  User.register_custom_field_type("skylockr_membership_expires", :date)
  
  # Add to user serializer
  add_to_serializer(:user, :xrp_wallet_address, false) do
    object.custom_fields["xrp_wallet_address"]
  end
  
  add_to_serializer(:user, :xrp_wallet_verified, false) do
    object.custom_fields["xrp_wallet_verified"]
  end
  
  add_to_serializer(:user, :skylockr_membership_tier, false) do
    object.custom_fields["skylockr_membership_tier"] || "entry"
  end
  
  # Whitelist custom fields
  register_editable_user_custom_field("xrp_wallet_address")
  register_editable_user_custom_field("xrp_wallet_network")
  
  # Add membership tier badge
  add_to_serializer(:user_card, :membership_tier_badge) do
    tier = object.custom_fields["skylockr_membership_tier"] || "entry"
    {
      tier: tier,
      icon: membership_tier_icon(tier),
      label: tier.capitalize
    }
  end
  
  # XRP Wallet Routes
  Discourse::Application.routes.append do
    namespace :xrp_wallet do
      post "connect" => "wallet#connect"
      post "disconnect" => "wallet#disconnect"
      get "verify/:uuid" => "wallet#verify"
      get "balance/:address" => "wallet#balance"
      post "verify-membership" => "wallet#verify_membership"
    end
    
    # JamZia SSO
    post "/auth/jamzia/callback" => "jamzia_auth#callback"
    get "/auth/jamzia" => "jamzia_auth#initiate"
  end
  
  # Membership Tier Definitions
  MEMBERSHIP_TIERS = {
    entry: {
      name: "Entry",
      price: 0,
      features: [
        "Community App Access",
        "Basic Creator Tools",
        "5GB Storage",
        "Standard Support",
        "JamZia Builder Profile"
      ],
      min_xrp_balance: 0
    },
    pro: {
      name: "Pro",
      price: 19,
      features: [
        "Everything in Entry",
        "Republic Tier Access",
        "Advanced Analytics",
        "50GB Storage",
        "Priority Support",
        "Revenue Verification"
      ],
      min_xrp_balance: 100
    },
    master: {
      name: "Master",
      price: 49,
      features: [
        "Everything in Pro",
        "Metaverse Access",
        "Galaxy Tier Preview",
        "Unlimited Storage",
        "VIP Support",
        "White-Label Options",
        "Team Collaboration"
      ],
      min_xrp_balance: 500
    },
    prime: {
      name: "Prime",
      price: 99,
      features: [
        "Everything in Master",
        "Universe & GodVerse",
        "Full Ecosystem Access",
        "Dedicated Account Manager",
        "API Access",
        "Custom Integrations",
        "Revenue Share Program",
        "Early Feature Access"
      ],
      min_xrp_balance: 2000
    }
  }
  
  # Helper methods
  def membership_tier_icon(tier)
    icons = {
      "entry" => "🌱",
      "pro" => "⚡",
      "master" => "👑",
      "prime" => "💎"
    }
    icons[tier] || "🌱"
  end
  
  # Guard clauses for wallet operations
  add_guardian_method(:can_connect_xrp_wallet?) do
    authenticated? && !is_anonymous?
  end
  
  add_guardian_method(:can_verify_membership?) do
    authenticated? && user.custom_fields["xrp_wallet_verified"]
  end
end

# Plugin metadata
discourse_config.skylockr_xrp_wallet = {
  version: "1.0.0",
  xumm_api_key: ENV["XUMM_API_KEY"],
  xumm_api_secret: ENV["XUMM_API_SECRET"],
  xrpl_network: ENV["XRP_NETWORK"] || "mainnet",
  xrpl_rpc_url: ENV["XRP_RPC"] || "https://s1.ripple.com:51234",
  jamzia_sso_endpoint: ENV["JAMZIA_SSO"] || "https://auth.jamzia.com"
}
