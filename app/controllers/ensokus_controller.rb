class EnsokusController < ApplicationController
  before_action :set_oyatsus, only: %i[new]
  before_action :set_ensoku, only: %i[show edit update destroy]

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
      @ensoku = Ensoku.create(purse: session[:purse])
      # ensokuに紐づくoyatsuをbasketに保存
      session_oyatsus = session[:oyatsus]
      session_oyatsus.each do |s_oyatsu|
        Basket.create(oyatsu_id: s_oyatsu[:oyatsu_id], ensoku_id: @ensoku.id, quantity: s_oyatsu[:quantity])
      end
    end
    session[:oyatsus].clear
    session[:purse].clear
    session[:ensoku] = @ensoku
    redirect_to ensoku_path(@ensoku), success: t('.success')
  end

  # おかし選択結果
  def show; end

  # 選択結果のステータス編集
  def edit; end

  # 選択結果のステータス更新
  def update
    @ensoku.user_id = current_user.id if logged_in?
    if @ensoku.update(ensoku_params)
      redirect_to @ensoku, success: t('.success')
    else
      flash.now[:danger] = t('.failure')
      render 'edit'
    end
  end

  # 削除後は新規遠足作成画面に遷移
  def destroy
    @ensoku.destroy!
    redirect_to new_ensoku_path, success: t('.success')
  end

  private

  def set_ensoku
    @ensoku = Ensoku.find(params[:id])
  end

  # 選択されてるおやつだけをset。数量は気にしない。
  def set_oyatsus
    session_oyatsus = session[:oyatsus]
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
