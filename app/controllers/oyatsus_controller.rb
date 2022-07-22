# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :check_request, :set_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end

  private

  # リファラを参照
  def check_request
    referer = request.referer
    # URL直打ち対策
    if referer.blank?
      if logged_in?
        redirect_to new_ensoku_path
      else
        redirect_to root_path
      end
      return
    end
    # リファラ制御
    redirect_to new_ensoku_path unless referer.include?(root_path) || referer.include?(new_ensoku_path)
  end

  def set_ensoku
    # セッション情報がある場合
    if session[:ensoku_id].present?
      @ensoku = Ensoku.find(session[:ensoku_id])
    # セッション情報がない場合
    elsif params[:ensoku].preset?
      @ensoku = Ensoku.find(:ensoku)
    else
      redirect_to new_ensoku_path
    end
  end
end
