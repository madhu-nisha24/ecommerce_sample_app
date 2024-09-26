class Api::V1::OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update]
  before_action :set_product, only: [:index, :new, :create]

  def index
    @orders = Order.where(user_id: current_user.id)

    respond_to do |format|
      format.json { render json: @orders.as_json(only: [:id, :created_at, :total_amount]) }
      format.html { render :index }
      format.any { render :index }
    end
  end

  def show
    @order = Order.find(params[:id])

  end

  def new
    @product = Product.find(params[:product_id])
    @order = @product.orders.build
    @message = flash[:notice] || flash[:alert] # Optional: to carry over flash messages
    @message_type = flash[:type] || :notice
  end

  def create
    Rails.logger.debug("-------Parameters: #{params.inspect}")
    @order = @product.orders.build(order_params)
    @order.user = current_user
    Rails.logger.debug("Order Params: #{params.inspect}")

    if @order.save
      puts @order.quantity, @product.quantity
      if @order.quantity > @product.quantity
        flash[:notice] = 'Order quantity exceeds the stock available'
        redirect_to api_v1_product_orders_path(@product, @order), notice: 'Order quantity exceeds the stock available'
      else
        OrderMailJob.perform_later(@order.id)
        @product.quantity = @product.quantity - @order.quantity
        @product.save
        flash[:notice] = 'Order was successfully created.'
        redirect_to api_v1_product_orders_path(@product, @order), notice: 'Order was successfully created.'
      end
    end
  end

  def edit

  end

  def update

  end

  def set_product
    @product = Product.find(params[:product_id]) if params[:product_id]
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:product_id, :quantity, :status)

  end

  def notify_me
    # Logic to save the notification request
    Notification.create(email: current_user.email, product_id: params[:product_id]) if current_user
    render json: { message: 'You will be notified when the product is back in stock.' }, status: :ok
  end
end
