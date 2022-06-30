class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create], raise: false

  def new
    redirect_to new_user_ensoku_path(current_user.id) if logged_in?
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to new_user_ensoku_path(current_user.id), success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
