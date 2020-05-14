class OrdersController < ApplicationController
  def new
    @order = Order.new do |order|
      order.build_order_items(current_cart)
      order
    end
  end

  def create
    if current_cart.cart_items.blank?
      redirect_to new_order_url, alert: 'カートに商品がありません'
      return
    end

    @order = current_user.orders.build(order_params) do |order|
      if params[:order][:ship_date].present?
        order.ship_date = Date.parse(params[:order][:ship_date])
        order.build_order_items(current_cart)
      end
      order
    end

    if @order.save
      clear_current_cart
      redirect_to root_url, notice: '注文を受け付けました！'
    else
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit(%i[address ship_time])
  end
end
