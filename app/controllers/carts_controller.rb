class CartsController < ApplicationController
  before_action :set_cart_item!, only: %i[add_item update_item delete_item]

  def show
    @cart_items_merchants = current_cart.cart_items_merchants
  end

  def add_item
    if @cart_items.blank?
      @cart_item = current_cart.cart_items.find_or_initialize_by(item_id: params[:cart_item][:item_id])
    end

    @cart_item.quantity += params[:cart_item][:quantity].to_i
    @cart_item.save

    redirect_to item_url(@cart_item.item), notice: "カートに#{@cart_item.item.name}を追加しました！"
  end

  def update_item
    @cart_item.update(quantity: params[:quantity].to_i)
    redirect_to cart_url
  end

  def delete_item
    @cart_item.destroy
    redirect_to cart_url
  end

  private

  def set_cart_item!
    @cart_item = current_cart.cart_items.find_by(item_id: params[:item_id])
  end
end
