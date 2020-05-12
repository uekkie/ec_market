require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end
  let!(:user) { create(:user) }

  it "ログイン後、トップ画面にリダイレクトされる" do
    visit root_path

    click_link "ログイン"

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(current_path).to eq root_path
  end


  context "ログインしているとき" do

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
    let!(:cart_item) { create(:cart_item, user: user, item: item, quantity: 1) }

    it '商品を購入できる' do
      visit cart_users_path

      # within '.items' do
      #   expect(page).to have_content 'りんご'
      # end
      #
      select '配送時間帯', from: '8-12'

      within '.amount' do
        expect(page).to have_content '300円'
      end

      expect {
        click_on '購入する'
      }.to change { ShippingItem.count }.by(1)
    end
  end
end
