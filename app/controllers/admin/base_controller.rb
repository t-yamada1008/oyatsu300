class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout 'admin/layouts/application'

  def not_authorized
    flash[:warning] = t('defaults.message.not_authorized')
  end

  def check_admin
    redirect_to rootpath, warning: t('defaults.message.not_authorized') unless current_user.admin?
  end
end
