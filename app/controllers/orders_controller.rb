class OrdersController < ApplicationController
  def new
    @order      = Order.new
    @cart_items = current_cart.cart_items
  end

  def create

  end
end
