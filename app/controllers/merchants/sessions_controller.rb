# frozen_string_literal: true

class Merchants::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  protected

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  end
end
