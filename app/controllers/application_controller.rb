class ApplicationController < ActionController::Base
    require 'square'
    require 'securerandom'

    
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
        address = order.addresses.detect {|addr| addr.addr_type == "billing"}
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

    

end
