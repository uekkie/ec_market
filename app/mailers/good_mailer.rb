class GoodMailer < ApplicationMailer
  def get_good(good)
    @good = good
    @post = @good.post

    mail(to: @post.user.email, subject: 'Goodが付きました')
  end
end
