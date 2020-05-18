class ItemsController < ApplicationController
  before_action :set_item, only: %i[show]

  def index
    if admin_signed_in?
      redirect_to admins_items_url
    end
    @items = current_shop.items.displayed
  end

  def show
    @cart_item = current_cart.cart_items.build
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
