class ShippingController < ApplicationController
    # before_action :verify_authenticity_token, only: [:calculate_shipping]
    def calculate_shipping
        # binding.irb
        render json: shipping_calculation
        #needs to pass in shipping level and address
      end

      private

      def shipping_params
        params.require(:order).permit(:quantity, :shippingOption, addresses: [:address_1, :address_2, :city, :state, :zipcode])
      end
end


