class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.recent
  end

  def show

  end

  def new
    @merchant_id = params[:merchant_id]
    @order       = current_user.orders.build do |order|
      order.build_order_items(current_cart, @merchant_id)
      order.address = current_user.shipping_address&.address
      order
    end
  end

  def create
    if current_cart.empty?
      redirect_to new_order_url, alert: 'カートに商品がありません'
    end
    @merchant_id = params[:order][:merchant_id]

    customer = params[:use_registered_id].present? ?
                   current_user.customer :
                   current_user.attach_customer(params[:stripeToken])

    @order = current_user.orders.build(order_params) do |order|
      order.build_order_items(current_cart, @merchant_id)
      order
    end

    if @order.save && current_user.charge(customer, @order.total_with_tax)
      current_user.use_point(@order)
      clear_current_cart
      redirect_to root_url, notice: '注文を受け付けました！'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(%i[address ship_time ship_date user_point merchant_id])
  end
end
