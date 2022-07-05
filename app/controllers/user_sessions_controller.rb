class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create], raise: false

  def new
    redirect_to new_users_ensoku_path if logged_in?
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to new_users_ensoku_path, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path, success: t('.logout')
  end
end
