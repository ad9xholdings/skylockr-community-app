# XRP Ledger Client
# Direct XRPL node communication

# frozen_string_literal: true

require "net/http"
require "json"
require "websocket-client-simple"

module SkylockrXrpWallet
  class XrplClient
    NETWORKS = {
      mainnet: {
        rpc: "https://s1.ripple.com:51234",
        websocket: "wss://s1.ripple.com"
      },
      testnet: {
        rpc: "https://s.altnet.rippletest.net:51234",
        websocket: "wss://s.altnet.rippletest.net"
      },
      devnet: {
        rpc: "https://s.devnet.rippletest.net:51234",
        websocket: "wss://s.devnet.rippletest.net"
      }
    }.freeze
    
    def initialize(network: :mainnet)
      @network = network.to_sym
      @rpc_url = NETWORKS[@network][:rpc]
    end
    
    # Get account balance in XRP
    def get_account_balance(address)
      response = rpc_call("account_info", {
        account: address,
        strict: true,
        ledger_index: "current",
        queue: true
      })
      
      if response["result"]["account_data"]
        drops = response["result"]["account_data"]["Balance"].to_i
        drops_to_xrp(drops)
      else
        0
      end
    rescue StandardError => e
      Rails.logger.error("XRPL balance fetch failed: #{e.message}")
      0
    end
    
    # Get account transactions
    def get_account_transactions(address, limit: 20)
      response = rpc_call("account_tx", {
        account: address,
        ledger_index_min: -1,
        ledger_index_max: -1,
        binary: false,
        limit: limit,
        forward: false
      })
      
      response["result"]["transactions"] || []
    end
    
    # Verify transaction
    def verify_transaction(tx_hash)
      response = rpc_call("tx", {
        transaction: tx_hash,
        binary: false
      })
      
      response["result"]
    end
    
    # Check if account exists
    def account_exists?(address)
      response = rpc_call("account_info", {
        account: address,
        strict: true
      })
      
      response["result"]["account_data"].present?
    rescue StandardError
      false
    end
    
    # Get NFTs owned by account
    def get_account_nfts(address)
      response = rpc_call("account_nfts", {
        account: address,
        ledger_index: "validated"
      })
      
      response["result"]["account_nfts"] || []
    end
    
    # Subscribe to account transactions via WebSocket
    def subscribe_to_account(address, &block)
      ws_url = NETWORKS[@network][:websocket]
      
      WebSocket::Client::Simple.connect(ws_url) do |ws|
        ws.on :open do
          ws.send({
            command: "subscribe",
            accounts: [address]
          }.to_json)
        end
        
        ws.on :message do |msg|
          data = JSON.parse(msg.data)
          block.call(data) if block_given?
        end
        
        ws.on :close do |e|
          Rails.logger.info("XRPL WebSocket closed: #{e}")
        end
        
        ws.on :error do |e|
          Rails.logger.error("XRPL WebSocket error: #{e}")
        end
      end
    end
    
    private
    
    def rpc_call(method, params)
      uri = URI(@rpc_url)
      
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = {
        method: method,
        params: [params]
      }.to_json
      
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.read_timeout = 30
      
      response = http.request(request)
      
      unless response.is_a?(Net::HTTPSuccess)
        raise "XRPL RPC error: #{response.code}"
      end
      
      JSON.parse(response.body)
    end
    
    def drops_to_xrp(drops)
      drops.to_f / 1_000_000
    end
  end
end
