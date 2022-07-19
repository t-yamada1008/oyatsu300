class EveryoneOyatsusController < ApplicationController
  before_action :set_ensoku, only: %i[show]
  def index
    @ensokus = Ensoku.where(status: 'open')
  end

  def show; end

  private

  def set_ensoku
    # 公開ステータスがopen出ない場合、indexにredirect
    @ensoku = Ensoku.find(params[:id])
    redirect_to everyone_oyatsu_path  unless @ensoku.status == 'open'
  end
end
