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
    # let!(:cart) {
    #   cart = Cart.create
    #   session[:cart_id] = cart.id
    #   cart.cart_items.create(item: item, quantity: 2)
    #   cart
    # }

    it '商品を購入できる' do
      visit item_path(item)
      click_on 'カートに追加'

      visit new_order_path #

      fill_in '送り先', with: user.address
      select '8時〜12時', from: '配送時間帯'

      expect {
        click_on '購入を確定する'
      }.to change { Order.count }.by(1)
    end
  end
end
