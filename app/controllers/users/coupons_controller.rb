class Users::CouponsController < ApplicationController
  def index; end

  def new
    @coupon = Coupon.new
  end

  def create
    @coupon = Coupon.find_by(code: params[:coupon][:code])
    if @coupon
      if @coupon.used?
        @coupon.errors.add(:code, 'コードはすでに使用されています')
        render :new
      end
      current_user.charge_coupon(@coupon)
      redirect_to profile_users_url, notice: "#{@coupon.point}ポイントチャージされました"
    else
      @coupon = Coupon.new
      @coupon.errors.add(:code, 'コードが無効です')
      render :new
    end
  end
end
