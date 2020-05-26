require 'rails_helper'

RSpec.describe "Coupons", type: :system do
  let!(:admin) { create(:admin) }

  it '管理者はクーポンコードを発行できる' do
    sign_in admin
    visit admins_coupons_path
    click_on 'クーポンコードを発行'

    expect(current_path).to eq new_admins_coupon_path

    fill_in 'ポイント', with: '500'
    expect {
      click_on '登録する'
      expect(page).to have_content 'クーポンコードを発行しました'
    }.to change { Coupon.count }.by(1)

  end

  context 'ユーザーでログインしているとき' do
    let!(:user) { create(:user) }
    let!(:coupon) { create(:coupon) }

    it 'クーポンコードを入力してポイントを受け取れる' do
      sign_in user

      visit profile_users_path

      click_on 'クーポンコードを入力'

      fill_in '12桁のコードを入力', with: coupon.code

      expect {
        click_on 'ポイントを受け取る'
        user.reload
        expect(user.point).to eq 500

      }.to change { user.point }.by(500)

    end


  end

  context '管理者でログインしているとき' do
    let!(:admin){ create(:admin) }
    let!(:user){ create(:user) }
    let!(:coupon){ create(:coupon, point: 999) }
    before { sign_in admin }
    it 'クーポンの利用状況が確認できる' do
      visit admins_coupons_path

      within first('tbody > tr') do
        expect(page).to have_content 999
        expect(page).to have_content '未使用'
      end

      user.charge_coupon(coupon)

      visit admins_coupons_path

      within first('tbody > tr') do
        expect(page).to have_content 999
        expect(page).to have_content '使用済み'
        expect(page).to have_content user.display_name
      end
    end
  end
end
