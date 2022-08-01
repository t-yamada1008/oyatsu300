class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update delete]
  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def show; end

  def edit; end

  def update; end

  def delte; end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
