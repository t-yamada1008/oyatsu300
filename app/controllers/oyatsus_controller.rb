# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login, :check_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  private

  def check_ensoku
    redirect_to new_users_ensoku_path if @ensoku.blank?
  end
end
