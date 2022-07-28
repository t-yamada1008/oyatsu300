class BasketsController < ApplicationController
  def create
    @ensoku = Ensoku.find(params[:ensoku_id])
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
    if @ensoku.purse_under_zero?
      render 'alert'
    else
      @ensoku.basket_in(@oyatsu)
      @ensoku.update_purse
    end
  end

  def destroy
    basket = Basket.find(params[:id])
    @ensoku = basket.ensoku
    @oyatsu = basket.oyatsu
    basket.destroy!
    @ensoku.update_purse
  end
end
