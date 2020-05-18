class Admins::ItemsController < ApplicationController
  before_action :admin_signed_in?

  def index
    @items = Item.all.order(:position)
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to admins_items_url, notice: '商品を登録しました'
    else
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(%i[name price description image hidden position])
  end
end
