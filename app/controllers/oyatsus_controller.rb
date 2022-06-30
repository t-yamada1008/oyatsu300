# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login, :set_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  def set_ensoku
    @ensoku = Ensoku.find(params[:ensoku])
  end
end
