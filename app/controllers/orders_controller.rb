class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.recent
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def new
    gon.stripe_publishable_key = Rails.configuration.stripe[:publishable_key]
    @merchant_id = params[:merchant_id]
    @order       = current_user.orders.build do |order|
      order.build_order_items(current_cart, @merchant_id)
      order.address = current_user.shipping_address&.address
      order
    end
  end

  def create
    redirect_to new_order_url, alert: 'カートに商品がありません' if current_cart.empty?

    @order = current_user.orders.build(order_params) do |order|
      order.build_order_items(current_cart, order.merchant.id)
      order
    end

    if save_order(@order)
      current_user.use_point(@order)
      clear_current_cart
      redirect_to root_url, notice: '注文を受け付けました！'
    else
      render :new
    end
  end

  private

  def save_order(order)
    return order.save_and_charge(params[:use_registered_id], params[:stripeToken]) if order.purchased_type.credit_card?

    order.save
  end

  def order_params
    params.require(:order).permit(%i[address ship_time ship_date user_point merchant_id purchased_type])
  end
end
