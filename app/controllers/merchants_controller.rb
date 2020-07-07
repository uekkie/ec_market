class MerchantsController < ApplicationController
  before_action :authenticate_merchant!
  # def index
  #   @merchants = Merchant.recent
  # end

  def profile
    @merchant = current_merchant
  end

  def update
    @merchant = Merchant.find(params[:id])
    if @merchant.update(merchant_params)
      redirect_to profile_merchants_url, notice: '更新しました'
    else
      redirect_to profile_merchants_url, alert: '更新できませんでした'
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:quantity_per_box)
  end
end
