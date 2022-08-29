class BasketsController < ApplicationController
  before_action :set_oyatsu, only: %i[basket_in basket_out]

  def basket_in
    # 変数初期化
    results_arr = []
    oyatsus_arr = session[:oyatsus]
    purse = session[:purse]
    @basket_error_message = t('.purse_over')
    ## 金額チェック
    # そもそも残りのおこづかいが0円
    # result_purseでzero?判定するとちょうど残高0円になる場合も弾いてしまうため
    return @basekt_error_message  if purse.zero?

    # 計算
    result_purse = purse - @oyatsu.price
    # 0円以下だと弾く
    return @basket_error_message if result_purse.negative?

    ## おやつ追加チェック
    # セッションにおやつが何も存在しない場合
    if oyatsus_arr.blank?
      results_arr.push({ oyatsu_id: @oyatsu.id, quantitiy: 1 })
    # oyatsusに@oyatsu.idが含まれていない場合
    elsif oyatsus_arr.find { |f| f[:oyatsu_id] == @oyatsu.id }.blank?
      # 既存のおやつに新規のおやつをpush
      oyatsus_arr.push({ oyatsu_id: @oyatsu.id, quantitiy: 1 })
      results_arr = oyatsus_arr
    # oyatsusに@oyatsu.idが含まれている場合
    else
      oyatsus_arr.each do |oyatsu|
        oyatsu_id = oyatsu[:oyatsu_id].to_i
        quantitiy = if oyatsu_id == @oyatsu.id
                      oyatsu[:quantitiy].to_i + 1
                    else
                      oyatsu[:quantitiy].to_i
                    end
        results_arr.push({ oyatsu_id:, quantitiy: })
      end
    end
    session[:oyatsus] = results_arr
    session[:purse] = result_purse
  end

  def basket_out
    results_arr = []
    oyatsus_arr = session[:oyatsus]
    oyatsus_arr.each do |oyatsu|
      oyatsu_id = oyatsu[:oyatsu_id].to_i
      quantitiy = oyatsu[:quantitiy].to_i
      # おやつidが一致する場合は計算処理
      quantitiy -= 1 if oyatsu_id == @oyatsu.id
      # 0になる場合はresultsにpushしない
      next if quantitiy.zero?

      # 0にならない or おやつidが一致しない場合はpush
      results_arr.push({ oyatsu_id:, quantitiy: })
    end
    session[:oyatsus] = results_arr
    # バスケットにおやつの値段を追加
    session[:purse] += @oyatsu.price
  end

  private

  def set_oyatsu
    @oyatsu = Oyatsu.find(params[:oyatsu_id])
  end
end
