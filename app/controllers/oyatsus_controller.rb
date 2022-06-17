# Oyatsus Contorller
class OyatsusController < ApplicationController
  before_action :require_login

  def index
    @oyatsus = Oyatsu.all.page(params[:page])
  end
end
