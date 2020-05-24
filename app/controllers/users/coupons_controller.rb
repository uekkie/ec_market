class Users::CouponsController < ApplicationController
  def index

  end

  def new
    @coupon = Coupon.new
  end

  def create
    if @coupon = Coupon.find_by(code: params[:coupon][:code])
      if @coupon.used
        @coupon.errors[:code] = 'すでに使用されています'
        render :new
      end
      current_user.charge_coupon(@coupon)
      redirect_to profile_users_url, notice: "#{@coupon.point}ポイントチャージされました"
    else
      msg = @coupon.nil? ? '無効です' : 'すでに使用されています'
      # redirect_to profile_users_url, alert: 'クーポンコードは#{msg}'
      render :new
    end
  end
end
