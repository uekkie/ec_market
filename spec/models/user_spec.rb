require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  let!(:coupon_100) { create(:coupon, point: 100) }
  let!(:used_coupon) { create(:coupon, user: user) }

  it 'ユーザーは、コードを入力してポイントを受け取れる' do
    expect(user.point).to eq 0
    user.charge_coupon(coupon_100)
    expect(user.point).to eq 100
  end

  it 'コードが使用済みの場合、ポイントは受け取れない' do
    expect(user.point).to eq 0
    user.charge_coupon(used_coupon)
    expect(user.point).to eq 0
  end
end
