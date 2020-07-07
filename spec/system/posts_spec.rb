require 'rails_helper'

RSpec.describe '日記', type: :system do
  let!(:user) { create(:user) }
  before { sign_in user }
  describe '投稿' do
    it '投稿できる' do
      visit new_post_path
      expect(current_path).to eq new_post_path
      fill_in 'タイトル', with: '栽培キットを買った'
      fill_in '本文', with: '今日から日記をつけていく！'
      expect do
        click_on '登録する'
      end.to change { Post.count }.by(1)
    end

    it '正しくない値は再入力する' do
      visit new_post_path
      expect(current_path).to eq new_post_path
      fill_in 'タイトル', with: ''
      fill_in '本文', with: '今日から日記をつけていく！'

      click_on '登録する'

      expect(page).to have_content 'タイトルを入力してください'
    end
  end

  let(:post) { create(:post, user: user, title: 'おはようｇざいます', content: '1日目のログ。') }

  describe '更新' do
    it '更新できる' do
      visit edit_user_post_path(post.user, post)

      fill_in 'タイトル', with: 'おはようございます！'
      fill_in '本文', with: '1日目のログ👍'

      click_on '更新する'

      post.reload

      expect(post.title).to eq 'おはようございます！'
      expect(post.content).to eq '1日目のログ👍'
    end

    it '正しくない値では更新できない' do
      visit edit_user_post_path(post.user, post)

      fill_in '本文', with: ''

      click_on '更新する'

      post.reload

      expect(page).to have_content '本文を入力してください'
    end
  end

  it '削除できる', js: true do
    visit user_post_path(post.user, post)

    within first('.post-actions') do
      expect do
        click_on '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
        page.accept_confirm
        sleep 0.5
      end.to change { Post.count }.by(-1)
    end
    expect(current_path).to eq posts_path
    expect(page).to have_content '削除しました'
  end
end
