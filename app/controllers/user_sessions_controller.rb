class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create], raise: false

  def new
    redirect_to ensokus_path if logged_in?
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      binding.pry
      set_ensoku_user if session[:ensoku_id].present?
      redirect_back_or_to ensokus_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.logout')
  end

  private

  def set_ensoku_user
    # 遠足のセッション情報が存在する場合、ユーザーと紐付けて登録
    @ensoku = Ensoku.find(session[:ensoku_id])
    @ensoku.user_id = @user.id
    @ensoku.save
  end
end
