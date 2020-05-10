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
      }.to change { user.cart_items.count }.by(1)
    end
  end
end
