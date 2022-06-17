class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create], raise: false

  # 遠足のおやつは300円まで
  OKOZUKAI = 300

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.purse = OKOZUKAI

    if @user.save
      redirect_to '/', success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
