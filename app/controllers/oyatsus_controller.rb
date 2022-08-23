# Oyatsus Contorller
class OyatsusController < ApplicationController
  def index
    @q = Oyatsu.ransack(params[:q])
    @oyatsus = @q.result.page(params[:page])
  end
end
