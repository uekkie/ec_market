class ApplicationController < ActionController::Base
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart              = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  def clear_current_cart
    session[:cart_id] = nil
  end

  def admin_signed_in?
    return false unless user_signed_in?
    current_user.admin
  end

  def current_shop
    Shop.find(1)
  rescue ActiveRecord::RecordNotFound
    Shop.create
  end

  helper_method :current_cart
  helper_method :admin_signed_in?


  private

  def after_sign_in_path_for(resource_or_scope)
    if admin_signed_in?
      admins_items_path
    else
      items_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
