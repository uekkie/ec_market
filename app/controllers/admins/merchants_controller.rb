class Admins::MerchantsController < Admins::ApplicationController
  def index
    @merchants = Merchant.recent
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def destroy
    @merchant = Merchant.find(params[:id])
    @merchant.destroy!
    redirect_to admins_merchants_url, notice: "#{@merchant.name}を削除しました"
  end
end
