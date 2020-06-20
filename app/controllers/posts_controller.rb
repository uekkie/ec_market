class PostsController < ApplicationController
  before_action :set_post, only: %i[show]

  def index
    @posts = Post.recent
  end

  def show
    # @user = current_user
    # @comment = Comment.new
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

end
