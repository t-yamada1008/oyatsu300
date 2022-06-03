class BasketsController < ApplicationController
  before_action :set_basket, only: %i[destroy]
  skip_before_action :require_login, only: %i[index], raise: false

  def index
    @baskets = Basket.where(user_id: params[:user_id])
  end

  def new
    @basket = Basket.new
  end

  def create
    @basket = @user.baskets.build(basket_params)

    if @basket.save
      redirect_to choose_oyatsu_path, success: 'せいこう'
    else
      # TODO: renderに変更
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
    params.require(:basket).permit(:quantity, :oyatsu_id)
  end
end
