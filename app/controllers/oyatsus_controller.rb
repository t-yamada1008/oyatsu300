# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login, :set_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  private

  def set_ensoku
    if @ensoku.blank?

    end
    @ensoku = current_user.ensokus.create if current_user.ensokus.blank?
  end
end
