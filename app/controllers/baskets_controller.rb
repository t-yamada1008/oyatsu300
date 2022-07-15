class BasketsController < ApplicationController
  def create
    @ensoku = Ensoku.find(params[:ensoku_id])
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
    if @ensoku.purse_under_zero?
      redirect_to choose_oyatsu_path ensoku: @ensoku, flash: { notice: 'ng' }
    else
      @ensoku.basket_in(@oyatsu)
      @ensoku.update_purse
      redirect_to choose_oyatsu_path ensoku: @ensoku, flash: { notice: 'ok' }
    end
  end

  def destroy
    basket = Basket.find(params[:id])
    @ensoku = basket.ensoku
    basket.destroy!
    @ensoku.update_purse
    redirect_to choose_oyatsu_path ensoku: @ensoku, flash: { notice: 'ok' }
  end
end
