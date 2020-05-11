class CartItemsController < ApplicationController
  before_action :authenticate_user!

  def show
    @cart_item = current_user.cart_item
  end

  def create
    @cart_item = CartItem.new(cart_item_params) do |cart_item|
      cart_item.user = current_user
      cart_item
    end
    if @cart_item.save
      redirect_to item_url(@cart_item.item), notice: "#{@cart_item.item.name}をカートに追加しました"
    else
      redirect_to item_url(@cart_item.item), alert: "追加できませんでした"
    end
  end

  def destroy

  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:quantity, :user_id, :item_id)
  end
end
