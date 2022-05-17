# User
class UsersController < ApplicationController
  require 'securerandom'

  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.email = "#{SecureRandom.uuid}@example.com"
    @user.purse = 300

    if @user.save
      logout if logged_in?
      auto_login(@user)
      redirect_to choose_oyatsu_path, success: 'せいこう'
    else
      flash.now[:danger] = 'しっぱい'
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
