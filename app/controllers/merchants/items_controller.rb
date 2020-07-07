class Merchants::ItemsController < Merchants::ApplicationController
  before_action :set_item, only: %i[edit update destroy]

  def index
    @items = current_merchant.items.recent
  end

  def show; end

  def new
    @item = current_merchant.items.build
  end

  def edit; end

  def create
    @item = current_merchant.items.build(item_params)

    if @item.save
      redirect_to merchants_items_url, notice: '商品を登録しました'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to merchants_item_path(@item), notice: '変更しました'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy!
    redirect_to merchants_items_url, notice: "#{@item.name}を削除しました"
  end

  private

  def item_params
    params.require(:item).permit(%i[name price description image hidden position])
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
