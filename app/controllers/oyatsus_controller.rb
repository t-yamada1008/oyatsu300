# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login, :check_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  private

  def check_ensoku
    if params[:ensoku].present?
      @ensoku = Ensoku.find(params[:ensoku])
    # 検索時にsearch_form_forでparamsを渡せないのでhiddenで渡す
    elsif params[:q][:ensoku].present?
      @ensoku = Ensoku.find(params[:q][:ensoku])
    else
      redirect_to new_users_ensoku_path
    end
  end
end
