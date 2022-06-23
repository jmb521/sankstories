class ApplicationController < ActionController::Base
    require 'square'
    require 'securerandom'
    require 'json'
    require 'net/http'
    require 'uri'
    skip_before_action :verify_authenticity_token
    
    def gon_variables
        gon.appId = ENV["APPLICATION_ID"]
        gon.locationId = ENV["LOCATION_ID"]
    end
    

    def client
        client = Square::Client.new(
        access_token: ENV['ACCESS_TOKEN'],
        environment: 'sandbox'
        #change to production when ready
        )
    end

    def square_create_customer(order)
        address = order.addresses.detect {|addr| addr.addr_type == "mailing"}
        result = client.customers.create_customer(
            body: {
              given_name: order.purchaser.first_name,
              family_name: order.purchaser.last_name,
              address: {
                address_line_1: address.address_1,
                address_line_2: "#{address.city}, #{address.state} #{address.zipcode}"
              },
              idempotency_key: SecureRandom.uuid
            }
          )
    end
    
    def payments_api
        payments_api = client.payments
    end


    ### shipping methods


    def send_to_shipper
      token = get_lulu_access_token
      uri = URI('https://api.lulu.com/print-jobs/')
      request = Net::HTTP::Post.new(uri)
      request["content-type"] =  "application/json"
      request["Authorization"] = "Bearer #{token}"
      request["Cache-Control"] = 'no-cache'

      request.body = "{" +
	"    \"contact_email\": \"jasonrsank@gmail.com\"," +
      line_items(@order.quantity) + 
	"    \"production_delay\": 120," +
      shipping_address_info(@order) +
	"    \"shipping_level\": \"#{@order.shipping_level}\"" +
	"}"
      Net::HTTP.start(uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https') do |http|
        
        response = http.request request # Net::HTTPResponse object
        binding.irb
      end
    end


    def shipping_address_info(order)

      shipping_address = { 
        
        "city": "#{order["addresses"][0]["city"]}",
        "country_code": "US",
        "postcode": "#{order["addresses"][0]["zipcode"]}",
        "state_code": "#{order["addresses"][0]['state']}",
        "street1": "#{order["addresses"][0]["address_1"]}"
        }
      
      if order["purchaser"]
        shipping_address["name"] = "#{order["purchaser"]["first_name"]} #{order["purchaser"]["last_name"]}"
        shipping_address["phone_number"] = order["purchaser"]["phone"]
      end
      shipping_address
    end


    def line_items(quantity)
      # "\"line_items\":[" +
      # "{" +
      # "\"external_id\": \"item-reference-1\"," +
      # "\"printable_normalization\": {" +
      # "\"cover\": {" +
      # "\"source_url\": \"https://drive.google.com/uc?export=download&id=1r1WDaaozrXbBZzLDYbCTSioPVm0L2BfE\"" +
      # "}," +
      # "\"interior\": {" +
      # "\"source_url\": \"https://drive.google.com/uc?export=download&id=1klAQEbaNhOQW0eg4E_GWHEG_AV42FXB_\"" +
      # "}," +
      # "\"pod_package_id\": \"0600X0900BWSTDPB060UW444GXX\"" +
      # "}," +
      # "\"quantity\": #{quantity}," +
      # "\"title\": \"Empire Remembered - Paperback\"" +
      # "}" +
      # "],"
      line_items = 
       [
        "external_id": "item-reference-1", 
        "printable_normalization": {
          "cover": {
            "source_url": "https://drive.google.com/uc?export=download&id=1r1WDaaozrXbBZzLDYbCTSioPVm0L2BfE"
          }, 
          "interior": {
            "source_url": "https://drive.google.com/uc?export=download&id=1klAQEbaNhOQW0eg4E_GWHEG_AV42FXB_"
          }, 
          "pod_package_id": "0600X0900BWSTDPB060UW444GXX",
          "quantity": "#{quantity.to_i}", 
          "title": "Empire Remembered - Paperback"
        }
      ]
    
  end

  

    def shipping_calculation
      token = get_lulu_access_token

      url = URI('https://api.lulu.com/print-job-cost-calculations/')
      # http = Net::HTTP.new(url.host, url.port, :use_ssl => url.scheme == 'https')
      
      request = Net::HTTP::Post.new(url)
      request["content-type"] =  "application/json"
      request["Authorization"] = "Bearer #{token}"
      request["Cache-Control"] = 'no-cache'
      body = {"line_items": line_items(params[:order][:quantity]), "shipping_level": params[:order][:shippingOption],  "shipping_address": shipping_address_info(params[:order])}.to_json
      request.body = body
      http = Net::HTTP.start(url.host, url.port, 
        :use_ssl => url.scheme == 'https') 
        response = http.request request # Net::HTTPResponse object
        binding.irb
      # end
    end


    def get_lulu_access_token
      url ="https://api.lulu.com/auth/realms/glasstree/protocol/openid-connect/token"
      uri = URI(url)
      request = Net::HTTP::Post.new uri
      request.set_form_data('grant_type' => "client_credentials")
      request["Authorization"] = ENV["AUTHORIZATION"]
      request["content-type"] =  "application/x-www-form-urlencoded"
      response = ""
      Net::HTTP.start(uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https') do |http|
        response = http.request request # Net::HTTPResponse object
      end
      JSON.parse(response.body)["access_token"]
    end


    

end
