# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :set_ensoku

  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
    set_ensoku_to_session if params[:ensoku_id].present?
  end

  private

  def set_ensoku
    @ensoku = Ensoku.find(params[:ensoku_id]) if params[:ensoku_id].present?
  end

  def set_ensoku_to_session
    session[:ensoku] = @ensoku
    session[:purse] = @ensoku.purse
    oyatsus_arr = []
    oyatsus = @ensoku.baskets
    oyatsus.each do |oyatsu|
      oyatsu_hash = { oyatsu_id: oyatsu.oyatsu_id, quantity: oyatsu.quantity }
      oyatsus_arr.push(oyatsu_hash)
    end
    session[:oyatsus] = oyatsus_arr
  end
end
