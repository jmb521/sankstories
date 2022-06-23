class OrdersController < ApplicationController

  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :gon_variables
  # skip_before_action :verify_authenticity_token, only: [:calculate_shipping]
  # GET /orders or /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  def show
    @shipping = shipping_options
  end

  # GET /orders/new
  def new
    @book = Book.find_by(isbn: params[:isbn])
      
    @order = @book.orders.build

    @order.purchaser = Purchaser.new
    # @order.addresses.build(addr_type: "billing")
    @order.addresses.build(addr_type: "mailing")
  end



 

  def thank_you

  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    if @order.valid?
      result = square_create_customer(@order)
  
      if result.success?
        #customer was entered correctly
        @order.status = "Customer Created"
        @order.purchaser.customer_id = result.body.customer[:id]
        
        @order.save
        
        redirect_to order_url(@order)
      end
    
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  def callback
    binding.irb
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:book_id, :quantity, purchaser_attributes: [:first_name, :last_name, :phone, :email], addresses_attributes: [:addr_type, :address_1, :address_2, :city, :state, :zipcode])
    end

end

