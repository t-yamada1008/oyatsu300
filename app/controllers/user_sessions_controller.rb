class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create], raise: false

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to choose_oyatsu_path, success: t('.success')
    else
      flash.now[:danger] = t('.failed')
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
