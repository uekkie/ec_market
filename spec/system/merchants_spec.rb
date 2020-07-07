require 'rails_helper'

RSpec.describe "Merchant", type: :system do
  let!(:merchant) { create(:merchant) }

  before { sign_in merchant }

  it '商品の追加と更新ができる' do
    visit merchants_items_path

    click_on '商品の追加'

    fill_in '商品名', with: 'りんご'
    fill_in '価格', with: 298
    fill_in '商品の説明', with: 'おいしすぎるりんご'

    expect {
      click_on '登録する'
    }.to change { Item.count }.by(1)

    expect(current_path).to eq merchants_items_path

    within first('.item') do
      click_on '編集'
    end
    # first("tbody tr").click '編集'

    fill_in '価格', with: 500
    click_on '更新する'

    expect(Item.last.price).to eq 500

  end

  it '商品の削除ができる', js: true do
    create(:item, name: '小魚', merchant: merchant)

    visit merchants_items_path

    within first('.item') do
      expect {
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
        page.accept_confirm
        expect(current_path).to eq merchants_items_path
      }.to change { Item.count }.by(-1)
    end
  end

  describe '送料' do
    it '業者が1箱の送料を設定できる' do

    end
  end
end
