class ApplicationController < ActionController::Base
    require 'square'
    require 'securerandom'


    def client
        client = Square::Client.new(
        access_token: ENV['ACCESS_TOKEN'],
        environment: 'sandbox'
        #change to production when ready
        )
    end

    def square_create_customer(order)
        address = order.addresses.find_by(addr_type: "billing")
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

          if result.success?
            customer = result.data.customer
            puts "New customer created with customer ID #{customer[:id]}"
          
          elsif result.error?
            result.errors.each do |error|
              warn error[:category]
              warn error[:code]
              warn error[:detail]
            end
          end
        #   binding.irb
    end
    
    def payments_api

        payments_api = client.payments
    end

    def create_payment(body:)
        # binding.irb
    end

end
