class EnsokusController < ApplicationController
  before_action :set_ensoku, only: %i[show edit update destroy]
  before_action :check_request, only: %i[show edit update destroy]

  # 遠足一覧画面
  # Userの全遠足結果を取得
  def index
    @ensokus = current_user.ensokus.all
  end

  # top画面
  # 新規遠足作成のボタンを置く
  def new; end

  # 新規遠足作成
  def create
    @ensoku = Ensoku.create
    # ログインしない場合のためにsessionを登録
    session.clear if session.present?
    session[:ensoku_id] = @ensoku.id
    redirect_to choose_oyatsu_path(ensoku: @ensoku)
  end

  # おかし選択結果
  def show; end

  # 選択結果のステータス編集
  def edit; end

  # 選択結果のステータス更新
  def update
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
    binding.pry
    @ensoku = Ensoku.find(params[:id])
  end

  def ensoku_params
    params.require(:ensoku).permit(:comment, :status)
  end

  # リファラを参照
  def check_request
    referer = request.referer
    # URL直打ち対策
    if referer.blank?
      if logged_in?
        redirect_to new_ensoku_path
      else
        redirect_to root_path
      end
      return
    end
    # リファラ制御
    redirect_to new_ensoku_path unless referer.include?(root_path) || referer.include?(choose_oyatsu_path(@ensoku))
  end
end
