# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login

  def index
    @ensoku = current_user.ensokus.create if @ensoku.blank?
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  private

  # 紐づく遠足がなければ遠足作成
  def check_ensoku

  end
end
