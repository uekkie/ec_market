require 'rails_helper'

RSpec.describe 'Goods', type: :system do
  let!(:post) { create(:post) }
  let!(:user) { create(:user) }

  it 'Goodがつけられる' do
    sign_in user
    visit user_post_path(post.user, post)
    expect {
      click_on 'Good!'
    }.to change { Good.count }.by(1)
  end

  it 'Goodを解除できる' do
    sign_in user
    post.goods.create!(user: user)

    visit user_post_path(post.user, post)
    expect {
      click_on 'Good解除'
    }.to change { Good.count }.by(-1)
  end

end
