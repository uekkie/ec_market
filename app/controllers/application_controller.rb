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

  helper_method :current_cart
end
