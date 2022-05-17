class BasketsController < ApplicationController
  before_action :set_basket, only: %i[destroy]

  def create
    @basket = Basket.new(basket_params)
    @basket.user_id = current_user.id

    if @basket.save
      redirect_to choose_oyatsu_path, success: 'せいこう'
    else
      redirect_to choose_oyatsu_path, success: 'しっぱい'
    end
  end

  def destroy
    @basket.destroy!
    redirect_to choose_oyatsu_path, success: 'せいこう'
  end

  private

  def set_basket
    @basket = Basket.find(params[:id])
  end

  def basket_params
    params.require(:oyatsu).permit(:quantity, :oyatsu_id)
  end
end
