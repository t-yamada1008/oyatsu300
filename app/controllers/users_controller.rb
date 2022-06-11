class UsersController < ApplicationController
  before_action :set_current_user, only: %i[edit update]
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

    if @user.save
      redirect_to login_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render :new
    end
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
    params.require(:user).permit(:name, :email, :password, :password_comfirmaition)
  end
end
