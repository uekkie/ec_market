require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

  it "ログイン後、トップ画面にリダイレクトされる" do
    visit root_path

    click_link "ログイン"

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(current_path).to eq root_path
  end


  context "管理者でログインしているとき" do
    let!(:admin) { create(:admin) }
    let!(:user) { create(:user) }

    before { sign_in admin }

    it 'クーポンのCRUDができる' do
      visit admins_coupons_path
      click_on 'クーポンコードを発行'

      fill_in 'ポイント', with: 1000
      expect {
        click_on '登録する'
      }.to change { Coupon.count }.by(1)

      coupon = Coupon.last
      expect(coupon.point).to eq 1000

      click_on coupon.display_code

      expect(page).to have_content '1000'
      expect(page).to have_content coupon.display_code

      first('tbody tr').click_link '変更'

      fill_in 'ポイント', with: 2000
      click_on '更新する'

      coupon.reload
      expect(coupon.point).to eq 2000
    end

    it 'クーポンを削除できる', js: true do
      create(:coupon)

      visit admins_coupons_path
      expect {
        first('tbody tr').click_link '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
        page.accept_confirm
        expect(current_path).to eq admins_coupons_path
      }.to change { Coupon.count }.by(-1)
    end

    it 'ユーザーのポイントを増減できる' do

      visit edit_users_point_path(user)

      fill_in '変更後のポイント', with: '500'
      expect {
        click_on 'ポイントを更新'
        user.reload
      }.to change { user.point }.by(500)
    end
  end

  context "ユーザーでログインしているとき" do

    before { sign_in user }
    let!(:item) { create(:item, name: "りんご", price: 300) }


    it "商品をカートに入れられる" do
      visit item_path(item)
      expect {
        click_button 'カートに追加'
        expect(current_path).to eq item_path(item)
      }.to change { CartItem.count }.by(1)
    end
  end

  context 'カートに商品が入っているとき' do
    before { sign_in user }
    let!(:item) { create(:item, name: "りんご", price: 300) }

    it '商品を購入できる' do
      visit item_path(item)
      click_on 'カートに追加'

      visit new_order_path

      fill_in '送り先', with: user.address
      select '8時〜12時', from: '配送時間帯'

      expect {
        click_on '購入を確定する'
      }.to change { Order.count }.by(1)
    end

    it '注文時にポイントが利用できる' do
      coupon_100 = create(:coupon, point: 100)
      user.charge_coupon(coupon_100)

      visit item_path(item)
      click_on 'カートに追加'

      visit new_order_path

      fill_in '送り先', with: user.address
      select '8時〜12時', from: '配送時間帯'
      fill_in 'ポイントを利用する', with: 100

      expect(user.point).to eq 100

      expect {
        click_on '購入を確定する'
      }.to change { Order.count }.by(1)

      user.reload
      expect(user.point).to eq 0
      order = Order.last
      expect(order.total_price).to eq order.total_with_tax - order.user_point
    end
  end
end
