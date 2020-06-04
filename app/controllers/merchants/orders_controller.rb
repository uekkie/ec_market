class Merchants::OrdersController < Merchants::ApplicationController
  def index
    @orders = current_merchant.orders.recent
  end
end
