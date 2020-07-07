class Admins::CouponsController < ApplicationController
  before_action :set_coupon, only: %i[show edit update destroy]

  def index
    @coupons = Coupon.recent
  end

  def show; end

  def new
    @coupon = Coupon.new
  end

  def edit; end

  def create
    @coupon = Coupon.new(coupon_params)

    if @coupon.save
      redirect_to admins_coupons_url, notice: 'クーポンコードを発行しました'
    else
      render :new
    end
  end

  def update
    if @coupon.update(coupon_params)
      redirect_to admins_coupons_url, notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @coupon.destroy!
    redirect_to admins_coupons_url, notice: '削除しました'
  end

  private

  def coupon_params
    params.require(:coupon).permit(:point)
  end

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end
end
