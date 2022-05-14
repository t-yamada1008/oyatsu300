# Oyatsus Contorller
class OyatsusController < ApplicationController
  def index
    @oyatsus = Oyatsu.all
  end
end
