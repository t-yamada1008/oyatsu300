class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :check_admin, only: %i[new create]
  layout 'admin/layouts/admin_login'

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to admin_root_path, success: t('.success')
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
