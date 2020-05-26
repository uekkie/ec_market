require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let!(:user) { create(:user) }
  let!(:coupon) { create(:coupon) }

  it 'つかったクーポンコードは使用済みになる' do
    expect(user.coupons.count).to eq 0

    user.charge_coupon(coupon)
    expect(user.coupons.find(coupon.id)).to be_truthy
    expect(coupon.user.present?).to be_truthy

    expect(coupon.used?).to be_truthy
    expect(user.coupons.count).to eq 1
  end
end
