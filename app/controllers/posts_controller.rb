class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.recent
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to post_url(@post), notice: '作成しました'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: '更新しました'
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
    @post = Post.find(params[:id])
  end

end
