class CommentMailer < ApplicationMailer
  def commented
    @comment = params[:comment]
    @post    = @comment.post

    mail(to: @post.user.email, subject: 'コメントが付きました')
  end
end
