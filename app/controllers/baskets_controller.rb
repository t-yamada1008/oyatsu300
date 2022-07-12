class BasketsController < ApplicationController
  def create
    @ensoku = Ensoku.find(params[:ensoku_id])
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
    @ensoku.basket_in(@oyatsu)
    redirect_to choose_oyatsu_path ensoku: @ensoku
  end

  def destroy
    basket = Basket.find(params[:id])
    @ensoku = basket.ensoku
    @oyatsu = basket.oyatsu
    basket.destroy!
    redirect_to choose_oyatsu_path ensoku: @ensoku
  end
end
