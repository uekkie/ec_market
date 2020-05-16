class ItemsController < ApplicationController
  before_action :set_item, only: %i[show]

  def index
    if admin_signed_in?
      redirect_to admins_items_url
    end
    @items = Item.all.order(:position)
  end

  def show
    @cart_item = current_cart.cart_items.build
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
