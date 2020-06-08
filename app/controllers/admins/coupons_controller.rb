class Admins::CouponsController < ApplicationController

  def index
    @coupons = Coupon.recent
  end

  def new
    @coupon = Coupon.new
  end


  def create
    @coupon = Coupon.new(coupon_params)

    if @coupon.save
      redirect_to admins_coupons_url, notice: 'クーポンコードを発行しました'
    else
      render :new
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:point)
  end
end
