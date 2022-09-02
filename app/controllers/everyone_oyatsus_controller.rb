class EveryoneOyatsusController < ApplicationController
  before_action :set_ensoku, only: %i[show]
  def index
    @ensokus = Ensoku.where(status: 'published')
  end

  def show; end

  private

  def set_ensoku
    # 公開ステータスがpublishedでない場合、indexにredirect
    @ensoku = Ensoku.find(params[:id])
    redirect_to everyone_oyatsus_path unless @ensoku.published?
  end
end
