# Oyatsus Contorller
class OyatsusController < ApplicationController
  def index
    @oyatus = Oyatsu.all
  end
end
