# User
class UsersController < ApplicationController
  before_action :set_current_user, only: %i[edit update]
  skip_before_action :require_login, only: %i[new create], raise: false
  require 'securerandom'

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.email = "#{SecureRandom.uuid}@example.com"
    @user.purse = 300

    if @user.save
      auto_login(@user)
      redirect_to choose_oyatsu_path, success: 'せいこう'
    else
      flash.now[:danger] = 'しっぱい'
      render 'new'
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

  def destroy
    logout if logged_in?
    redirect_to root_path
  end

  private

  def set_current_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:name, :comment)
  end
end
