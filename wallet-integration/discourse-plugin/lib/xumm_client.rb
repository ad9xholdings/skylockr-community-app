# XUMM Client
# Handles interactions with XUMM wallet API

# frozen_string_literal: true

require "net/http"
require "json"

module SkylockrXrpWallet
  class XummClient
    API_BASE = "https://xumm.app/api/v1"
    
    def initialize
      @api_key = SiteSetting.xumm_api_key || ENV["XUMM_API_KEY"]
      @api_secret = SiteSetting.xumm_api_secret || ENV["XUMM_API_SECRET"]
      
      raise "XUMM API credentials not configured" unless @api_key && @api_secret
    end
    
    # Create a sign-in payload
    def create_signin_payload(user_id:, return_url:)
      payload = {
        txjson: {
          TransactionType: "SignIn"
        },
        options: {
          submit: false,
          expire: 5,
          return_url: {
            app: return_url,
            web: return_url
          }
        },
        custom_meta: {
          identifier: "skylockr_#{user_id}",
          blob: {
            user_id: user_id,
            service: "SkyLockr Community"
          }.to_json
        }
      }
      
      response = post("/platform/payload", payload)
      
      {
        uuid: response["uuid"],
        qr_url: response["refs"]["qr_png"],
        xumm_app_url: response["next"]["always"]
      }
    end
    
    # Get payload status
    def get_payload(uuid)
      response = get("/platform/payload/#{uuid}")
      
      {
        uuid: response["meta"]["uuid"],
        status: response["meta"]["resolved"],
        signed: response["meta"]["signed"],
        expired: response["meta"]["expired"],
        response: response["response"]
      }
    end
    
    # Delete/cancel payload
    def delete_payload(uuid)
      delete("/platform/payload/#{uuid}")
    end
    
    # Get user token (for persistent connections)
    def get_user_token(ott)
      post("/platform/auth", { ott: ott })
    end
    
    private
    
    def get(endpoint)
      uri = URI("#{API_BASE}#{endpoint}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = auth_header
      request["Content-Type"] = "application/json"
      
      response = make_request(uri, request)
      JSON.parse(response.body)
    end
    
    def post(endpoint, body)
      uri = URI("#{API_BASE}#{endpoint}")
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = auth_header
      request["Content-Type"] = "application/json"
      request.body = body.to_json
      
      response = make_request(uri, request)
      JSON.parse(response.body)
    end
    
    def delete(endpoint)
      uri = URI("#{API_BASE}#{endpoint}")
      request = Net::HTTP::Delete.new(uri)
      request["Authorization"] = auth_header
      
      make_request(uri, request)
      true
    end
    
    def make_request(uri, request)
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.read_timeout = 30
      http.open_timeout = 10
      
      response = http.request(request)
      
      unless response.is_a?(Net::HTTPSuccess)
        raise "XUMM API error: #{response.code} - #{response.body}"
      end
      
      response
    end
    
    def auth_header
      "#{@api_key}:#{@api_secret}"
    end
  end
end
