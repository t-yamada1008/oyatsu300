class EnsokusController < ApplicationController
  before_action :set_ensoku, only: %i[show edit update destroy]
  before_action :set_oyatsus, only: %i[new edit]

  # 遠足一覧画面
  # Userの全遠足結果を取得
  def index
    @ensokus = current_user.ensokus.all
  end

  # 選択結果の作成画面
  def new
    @ensoku = Ensoku.new
  end

  # セッション情報から遠足を新規作成
  def create
    # トランザクションをかけてensokuとbasketを一括保存
    ActiveRecord::Base.transaction do
      # ensokuを作成し保存
      purse = session[:purse]
      @ensoku = if logged_in?
                  Ensoku.new(ensoku_params)
                else
                  @ensoku = Ensoku.new(purse:, status: 1)
                end
      if logged_in?
        @ensoku.user_id = current_user.id
        @ensoku.purse = purse
      end
      @ensoku.save
      # ensokuに紐づくoyatsuをbasketに保存
      session_oyatsus = session[:oyatsus]
      session_oyatsus.each do |s_oyatsu|
        Basket.create(oyatsu_id: s_oyatsu[:oyatsu_id], ensoku_id: @ensoku.id, quantity: s_oyatsu[:quantity])
      end
    end
    session[:oyatsus] = nil
    session[:purse] = nil
    session[:ensoku] = @ensoku
    redirect_to ensoku_path(@ensoku), success: t('.success')
  end

  # おかし選択結果
  def show; end

  # 選択結果のステータス編集
  def edit; end

  # 選択結果のステータス更新
  def update
    ActiveRecord::Base.transaction do
      # フォームの更新
      @ensoku.update(ensoku_params)
      # セッションの内容を更新
      # 金額更新
      purse = session[:purse]
      @ensoku.update(purse:)
      # バスケット更新
      if session[:oyatsus].present?
        session_oyatsus = session[:oyatsus]
        # セッション側検索
        session_oyatsus.each do |s_oyatsu|
          ## 同一おやつがあった場合、数量をアップデート
          # 既存バスケットをループし、マッチしたら更新
          @ensoku.baskets.each do |basket|
            basket.update(quantity: s_oyatsu[:quantity]) if basket.oyatsu_id == s_oyatsu[:oyatsu_id]
          end
          # @ensoku.basketsに該当おやつを追加する
          # 条件1: @ensoku.basketsに何も存在しない
          # 条件2: session_oyatsusに存在し@ensoku.basketsに存在しない場合
          if @ensoku.baskets.blank? || @ensoku.baskets.find { |o| o.oyatsu_id == s_oyatsu[:oyatsu_id] }.blank?
            Basket.create(oyatsu_id: s_oyatsu[:oyatsu_id], ensoku_id: @ensoku.id, quantity: s_oyatsu[:quantity])
          end
        end
        # @ensoku.baksets側検索
        # @ensoku.basketsに存在し、session_oyatsusに存在しない場合、@ensoku.basketsの該当おやつを削除する
        @ensoku.baskets.each do |basket|
          Basket.find(basket.id).delete if session_oyatsus.find { |k, v| k[:oyatsu_id] == basket.oyatsu_id }.blank?
        end
        session[:oyatsus] = nil
        session[:purse] = nil
      end
    end
    redirect_to @ensoku, success: t('.success')
  rescue ActiveRecord::RecordInvalid
    flash.now[:danger] = t('.failure')
    render 'edit'
  end

  # 削除後は新規遠足作成画面に遷移
  def destroy
    @ensoku.destroy!
    redirect_to ensokus_path, success: t('.success')
  end

  private

  def set_ensoku
    @ensoku = Ensoku.find(params[:id])
  end

  # 選択されてるおやつだけをset。数量は気にしない。
  def set_oyatsus
    session_oyatsus = []
    if session[:oyatsus].present?
      session_oyatsus = session[:oyatsus]
    else
      @ensoku.baskets.each do |basket|
        basket_hash = { oyatsu_id: basket[:oyatsu_id], quantity: basket[:quantity] }
        session_oyatsus.push basket_hash
      end
    end
    oyatsu_id_arr = []
    session_oyatsus.each do |s_oyatsu|
      oyatsu_id_arr.push(s_oyatsu[:oyatsu_id])
    end
    @oyatsus = Oyatsu.find(oyatsu_id_arr)
  end

  def ensoku_params
    params.require(:ensoku).permit(:comment, :status)
  end
end
