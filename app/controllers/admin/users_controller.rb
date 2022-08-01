class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update delete]
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render :edit
    end
  end

  def delte; end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
