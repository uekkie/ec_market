class Admins::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def require_admin
    unless admin_signed_in?
      redirect_to root_url, alert: '管理者権限が必要です'
    end
  end
end
