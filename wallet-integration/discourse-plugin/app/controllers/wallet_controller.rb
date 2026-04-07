// XRP Wallet Controller
// Handles XRP wallet connections and membership verification

# frozen_string_literal: true

module SkylockrXrpWallet
  class WalletController < ::ApplicationController
    requires_plugin PLUGIN_NAME
    
    before_action :ensure_logged_in
    skip_before_action :verify_authenticity_token, only: [:connect, :disconnect]
    
    # Initialize XUMM connection
    def connect
      return render json: { error: "Wallet already connected" }, status: 400 if current_user_wallet_connected?
      
      begin
        xumm_client = XummClient.new
        payload = xumm_client.create_signin_payload(
          user_id: current_user.id,
          return_url: wallet_callback_url
        )
        
        # Store pending connection
        Redis.current.setex(
          "xrp_wallet:pending:#{payload[:uuid]}",
          300, # 5 minutes expiry
          {
            user_id: current_user.id,
            created_at: Time.now.to_i
          }.to_json
        )
        
        render json: {
          uuid: payload[:uuid],
          qr_url: payload[:qr_url],
          xumm_app_url: payload[:xumm_app_url]
        }
      rescue StandardError => e
        Rails.logger.error("XUMM connection failed: #{e.message}")
        render json: { error: "Failed to initialize wallet connection" }, status: 500
      end
    end
    
    # Disconnect wallet
    def disconnect
      current_user.custom_fields.delete("xrp_wallet_address")
      current_user.custom_fields.delete("xrp_wallet_verified")
      current_user.custom_fields.delete("xrp_wallet_network")
      current_user.save_custom_fields
      
      render json: { success: true, message: "Wallet disconnected" }
    end
    
    # Verify XUMM payload completion
    def verify
      uuid = params[:uuid]
      
      # Check pending connection
      pending_data = Redis.current.get("xrp_wallet:pending:#{uuid}")
      return render json: { error: "Invalid or expired session" }, status: 404 unless pending_data
      
      pending = JSON.parse(pending_data, symbolize_names: true)
      
      # Verify with XUMM
      xumm_client = XummClient.new
      result = xumm_client.get_payload(uuid)
      
      if result[:signed] && result[:response][:account]
        wallet_address = result[:response][:account]
        
        # Update user
        user = User.find(pending[:user_id])
        user.custom_fields["xrp_wallet_address"] = wallet_address
        user.custom_fields["xrp_wallet_verified"] = true
        user.custom_fields["xrp_wallet_network"] = result[:response][:account][:network] || "mainnet"
        user.save_custom_fields
        
        # Clean up pending
        Redis.current.del("xrp_wallet:pending:#{uuid}")
        
        # Get balance
        balance = get_xrp_balance(wallet_address)
        
        # Determine membership tier based on balance
        tier = determine_membership_tier(balance)
        user.custom_fields["skylockr_membership_tier"] = tier.to_s
        user.save_custom_fields
        
        render json: {
          verified: true,
          address: wallet_address,
          balance: balance,
          network: user.custom_fields["xrp_wallet_network"],
          membership_tier: tier
        }
      else
        render json: { verified: false, status: result[:status] }
      end
    rescue StandardError => e
      Rails.logger.error("Wallet verification failed: #{e.message}")
      render json: { error: "Verification failed" }, status: 500
    end
    
    # Get wallet balance
    def balance
      address = params[:address]
      return render json: { error: "Address required" }, status: 400 unless address.present?
      
      balance = get_xrp_balance(address)
      render json: { address: address, balance: balance }
    rescue StandardError => e
      render json: { error: "Failed to fetch balance" }, status: 500
    end
    
    # Verify and update membership tier
    def verify_membership
      return render json: { error: "No wallet connected" }, status: 400 unless current_user_wallet_connected?
      
      address = current_user.custom_fields["xrp_wallet_address"]
      balance = get_xrp_balance(address)
      tier = determine_membership_tier(balance)
      
      current_user.custom_fields["skylockr_membership_tier"] = tier.to_s
      current_user.save_custom_fields
      
      render json: {
        tier: tier,
        balance: balance,
        address: truncate_address(address)
      }
    end
    
    private
    
    def current_user_wallet_connected?
      current_user.custom_fields["xrp_wallet_verified"].present? &&
        current_user.custom_fields["xrp_wallet_address"].present?
    end
    
    def get_xrp_balance(address)
      xrpl_client = XrplClient.new
      xrpl_client.get_account_balance(address)
    rescue StandardError
      0
    end
    
    def determine_membership_tier(balance)
      case balance
      when 0...100
        :entry
      when 100...500
        :pro
      when 500...2000
        :master
      else
        :prime
      end
    end
    
    def truncate_address(address)
      "#{address[0..6]}...#{address[-4..]}"
    end
    
    def wallet_callback_url
      "#{Discourse.base_url}/wallet/callback"
    end
  end
end
