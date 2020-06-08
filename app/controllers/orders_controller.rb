class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.recent
  end

  def show

  end

  def new
    @order = current_user.orders.build do |order|
      order.build_order_items(current_cart)
      order
    end
  end

  def create
    if current_cart.empty?
      redirect_to new_order_url, alert: 'カートに商品がありません'
    end

    @order = current_user.orders.build(order_params) do |order|
      order.build_order_items(current_cart)
      order
    end

    if @order.save
      current_user.use_point(@order)
      clear_current_cart
      redirect_to root_url, notice: '注文を受け付けました！'
    else
      # debugger
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(%i[address ship_time ship_date user_point])
  end
end
