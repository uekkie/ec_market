class GoodsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @good = current_user.goods.create!(user_id: current_user.id, post_id: @post.id)
    GoodMailer.with(good: @good).get_good.deliver_later
    @post.reload
  end

  def destroy
    good = current_user.goods.find_by!(user_id: current_user.id, post_id: @post.id)
    good.destroy!
    @post.reload
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
