class UsersController < ApplicationController
  before_action :set_current_user, only: %i[edit update]
  skip_before_action :require_login, only: %i[new create], raise: false
  require 'securerandom'

  # 遠足のおやつは300円まで
  OKOZUKAI = 300

  def index
    @users = User.all
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to users_path, success: 'せいこう'
    else
      flash.now[:danger] = 'しっぱい'
      redirect_to user_baskets_path(@user.id)
    end
  end

  private

  def set_current_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :comment)
  end
end
