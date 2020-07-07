class Users::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to user_post_url(@post.user, @post), notice: '作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to user_post_url(@post.user, @post), notice: '更新しました'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy!
    redirect_to posts_url, notice: '削除しました'
  end

  private

  def post_params
    params.require(:post).permit(%i[title content image])
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end

end
