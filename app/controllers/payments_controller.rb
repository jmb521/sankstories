class PaymentsController < ApplicationController
skip_before_action :verify_authenticity_token, only: [:payment]
    # POST /payment
    def payment
        @order = Order.find_by(id: params[:order][:id])
        payment = create_payment(params[:sourceId], @order)
        # render json: payment
    
    
        # respond_to do |format|
          if payment.success?
    #! need to write method to send request to lulu api or to redirect to another page for them to download book
            send_to_shipper
            # format.html { redirect_to payment_path(payment.body.payment[:id], payment: @payment.body.payment, notice: "Payment was successfully created." )}
            # format.json { payment}
          else
            # format.html { redirect_to action: :new, 'data-turbolinks': false,price: @order.book.price ,notice: "Payment was unprocessable" }
        #     #format.json { render json: @payment.errors, status: :unprocessable_entity }
          end
        # end
      end
      private

      
      def create_payment(nonce, order)
        # binding.irb
        location_id=ENV['LOCATION_ID']
        result = client.payments.create_payment(
          body: {
            source_id: nonce,
            idempotency_key: SecureRandom.uuid(),
            amount_money: {
              amount: (order.book.price.to_i.to_s + "00").to_i,
              currency: "USD"
            },
            location_id: location_id
          }
        )
        return result
      end
end
