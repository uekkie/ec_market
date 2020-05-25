class Users::PointsController < ApplicationController

  def index
    @users = User.normal.recent
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(point_params)
      redirect_to users_points_url, notice: "#{@user.display_name}さんのポイントを#{@user.point}に変更しました"
    else
      reder :edit
    end
  end

  private

  def point_params
    params.require(:user).permit(:point)
  end
end
