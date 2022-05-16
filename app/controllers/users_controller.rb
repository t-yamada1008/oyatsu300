# User
class UsersController < ApplicationController
  def index; end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to choose_oyatsu_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
