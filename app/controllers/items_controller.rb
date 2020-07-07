class ItemsController < ApplicationController
  before_action :set_item, only: %i[show]

  def index
    @items = Item.listed.displayed
  end

  def show
    @cart_item = current_cart.cart_items.build
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end
end
