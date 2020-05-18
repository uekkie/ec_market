class Admins::ItemsController < Admins::ApplicationController
  before_action :set_item, only: %i[show edit update destroy up_position down_position]

  def index
    @items = current_shop.items
  end

  def show
  end

  def new
    @item = current_shop.items.build
  end

  def edit
  end

  def create
    @item = current_shop.items.build(item_params)

    if @item.save
      redirect_to admins_items_url, notice: '商品を登録しました'
    else
      render :new
    end
  end

  def update
    if @item.update(item_params)
      redirect_to admins_item_path(@item), notice: '変更しました'
    else
      render :edit
    end
  end

  def destroy
    @item.destroy!
    redirect_to admins_items_url, notice: "#{@item.name}を削除しました"
  end

  def up_position
    @item.decrement_position
    redirect_to admins_items_url
  end

  def down_position
    @item.increment_position
    redirect_to admins_items_url
  end

  private

  def item_params
    params.require(:item).permit(%i[name price description image hidden position])
  end

  def set_item
    @item = Item.find(params[:id])
  end
end
