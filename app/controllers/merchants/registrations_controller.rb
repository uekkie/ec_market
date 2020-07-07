class Merchants::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create]
  before_action :configure_account_update_params, only: %i[update]
  before_action :creatable?, only: %i[new create]
  prepend_before_action :require_no_authentication, only: %i[cancel]
  # prepend_before_action :authenticate_scope!, only: %i[new create edit update destroy]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  def creatable?
    raise 'アクセス権限がありません' unless admin_signed_in?
  end

  def after_sign_up_path_for(_resource)
    admins_merchants_path
  end

  def after_update_path_for(_resource)
    admins_merchants_path
  end
end
