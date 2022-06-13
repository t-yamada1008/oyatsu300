class UsersController < ApplicationController
  before_action :set_current_user, only: %i[edit update]
  skip_before_action :require_login, only: %i[new create], raise: false

  # 遠足のおやつは300円まで
  OKOZUKAI = 300

  def index
    @users = User.all
  end

  def show; end

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

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user.id), success: t('.success')
    else
      binding.pry
      flash.now[:danger] = 'しっぱい'
      render :edit
    end
  end

  private

  def set_current_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
