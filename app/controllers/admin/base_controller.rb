class Admin::BaseController < ApplicationController
  before_action :require_login, :check_admin
  layout 'admin/layouts/application'

  def not_authorized
    flash[:warning] = t('.not_authorized')
  end

  def check_admin
    redirect_to root_path, warning: t('.not_authorized') unless current_user.admin?
  end
end
