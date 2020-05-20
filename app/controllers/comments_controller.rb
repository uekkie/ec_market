class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @post.comments.build(comment_params) do |comment|
      comment.user = current_user
      comment
    end

    if @comment.save
      CommentMailer.with(comment: @comment).commented.deliver_later
      redirect_to user_post_url(@post.user, @post), notice: 'コメントを作成しました'
    else
      render "posts/show"
    end
  end

  def destroy
    @comment.destroy!
    redirect_to user_post_url(@post.user, @post), notice: 'コメントを削除しました'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
