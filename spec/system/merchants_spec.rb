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


  context '注文済みが1件あるとき' do

    let!(:order_item) { create(:order_item) }
    let!(:order) { order_item.order }

    before { sign_in order.merchant }

    it '注文済みの確認ができる', js: true do
      expect(Order.count).to eq 1
      expect(OrderItem.count).to eq 1

      visit merchants_orders_path

      expect(page).to have_content '注文済みの一覧'

      within 'tbody' do
        expect(page).to have_content order.user.name
        expect(page).to have_content '注文済み'
      end
    end

    it '注文済みを発送処理中に変更できる' do
      visit merchants_orders_path

      first('tbody tr').click_link '発送処理中に変更'

      within 'tbody' do
        expect(page).to have_content '発送処理中'
      end
    end

    it '発送処理中を発送済みに変更できる' do
      order.prepare_shipping!

      visit merchants_orders_path

      first('tbody tr').click_link '発送中に変更'

      within 'tbody' do
        expect(page).to have_content '発送済み'
      end
    end
  end
end

