require 'rails_helper'

RSpec.describe 'Items', type: :system do
  describe '商品' do
    describe '管理者' do
      let!(:admin) { create(:admin) }
      before do
        sign_in admin
      end
      it '登録ができる' do
        visit admins_items_path
        click_on '商品の追加'

        fill_in '商品名', with: '伯方の塩'
        fill_in '価格', with: '1000'
        fill_in '説明', with: '伯方で取れた極上の塩'

        expect do
          click_on '登録する'
          expect(page).to have_content '伯方の塩を登録しました'
        end.to change { Item.count }.by(1)
      end

      it '登録失敗' do
        visit new_admins_item_path

        expect do
          click_on '登録する'
          expect(page).to have_content '商品名を入力してください'
        end.to change { Item.count }.by(0)
      end

      it '変更ができる' do
        item = create(:item, name: 'みかん', price: 200)
        visit edit_admins_item_path(item)

        fill_in '商品名', with: '最高級みかん'
        fill_in '価格', with: '1000'

        click_on '更新する'
        expect(page).to have_content '最高級みかんを変更しました'

        item.reload

        expect(item.name).to eq '最高級みかん'
        expect(item.price).to eq 1000
      end

      it '変更失敗' do
        item = create(:item, name: 'みかん', price: 200)
        visit edit_admins_item_path(item)

        fill_in '価格', with: ''

        expect do
          click_on '更新する'
          expect(page).to have_content '価格を入力してください'
        end.to change { Item.count }.by(0)
      end

      it '削除ができる', js: true do
        item = create(:item, name: 'みかん', price: 200)
        visit admins_item_path(item)

        expect do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
          page.accept_confirm
          expect(page).to have_content 'みかんを削除しました'
        end.to change { Item.count }.by(-1)
      end

      it '商品の並び替え' do
        apple = create(:item, name: 'りんご', price: 200, position: 1)
        grape = create(:item, name: 'ぶどう', price: 400, position: 2)
        peach = create(:item, name: 'もも', price: 600, position: 3)

        visit admins_items_path
        within first('.item') do
          click_on '下げる'
          apple.reload
          grape.reload
          expect(grape.position).to eq 1
          expect(apple.position).to eq 2
        end

        within all('.item').last do
          click_on '上げる'
          peach.reload
          apple.reload
          expect(peach.position).to eq 2
          expect(apple.position).to eq 3
        end
      end
    end
  end
end
