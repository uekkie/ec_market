class Users::OrderStatusesController < ApplicationController
  before_action :authenticate_user!

  def update
    order = current_user.orders.find(params[:id])
    if order.update(order_params)
      redirect_to orders_url, notice: "注文番号#{order.id}を#{order.status_i18n}しました"
    else
      redirect_to orders_url, alert: '変更できませんでした'
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end
end
