require 'rails_helper'

RSpec.describe "日記コメント", type: :system do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:commented_user) { create(:user) }

  describe '作成' do
    context 'ユーザーでログインしている' do
      before { sign_in commented_user }
      it 'コメントできる' do
        visit user_post_path(post.user, post)
        fill_in '本文', with: 'いいですね！'
        expect {
          click_on 'コメントする'
        }.to change { Comment.count }.by(1)
      end
    end
  end

  describe '削除' do
    context 'ユーザーでログインしている' do
      before { sign_in commented_user }
      let!(:comment) { create(:comment, user: commented_user, post: post, body: '参考になりました！') }
      it '削除できる', js: true do
        visit user_post_path(post.user, post)
        within first('.comments') do
          expect {
            click_on '削除'
            expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
            page.accept_confirm
            expect(current_path).to eq user_post_path(post.user, post)
          }.to change { Comment.count }.by(-1)
        end
      end
    end
  end
end
