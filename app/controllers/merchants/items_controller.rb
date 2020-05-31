class Merchants::ItemsController < Merchants::ApplicationController
  def index
    @items = Item.all
  end
end
