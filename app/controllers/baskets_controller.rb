class BasketsController < ApplicationController
  before_action :set_oyatsu, only: %i[basket_in basket_out]
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

  def basket_in
    results_arr = []
    oyatsus_arr = session[:oyatsus]
    # セッションに何も存在しない場合
    if oyatsus_arr.blank?
      results_arr.push({ oyatsu_id: @oyatsu.id, quantitiy: 1 })
    else
      # oyatsusに@oyatsu.idが含まれていない場合
      if oyatsus_arr.find { |f| f['oyatsu_id'] == @oyatsu.id }.blank?
        # 既存のおやつに新規のおやつをpush
        oyatsus_arr.push({ oyatsu_id: @oyatsu.id, quantitiy: 1 })
        results_arr = oyatsus_arr
      # oyatsusに@oyatsu.idが含まれている場合
      else
        oyatsus_arr.each do |oyatsu|
          oyatsu_id = oyatsu['oyatsu_id'].to_i
          quantitiy = if oyatsu_id == @oyatsu.id
                        oyatsu['quantitiy'].to_i + 1
                      else
                        oyatsu['quantitiy'].to_i
                      end
          results_arr.push({ oyatsu_id:, quantitiy: })
        end
      end
    end
    session[:oyatsus] = results_arr
  end

  def basket_out
    results_arr = []
    oyatsus_arr = session[:oyatsus]
    oyatsus_arr.each do |oyatsu|
      oyatsu_id = oyatsu['oyatsu_id'].to_i
      quantitiy = oyatsu['quantitiy'].to_i
      # おやつidが一致する場合は計算処理
      quantitiy -= 1 if oyatsu_id == @oyatsu.id
      # 0になる場合はresultsにpushしない
      next if quantitiy.zero?

      # 0にならない or おやつidが一致しない場合はpush
      results_arr.push({ oyatsu_id:, quantitiy: })
    end
    session[:oyatsus] = results_arr
  end

  private

  def set_oyatsu
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
  end
end
