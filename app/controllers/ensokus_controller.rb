class EnsokusController < ApplicationController
  before_action :set_ensoku, only: %i[show edit update destroy]
  before_action :check_request, only: %i[show edit update destroy]

  # 遠足一覧画面
  # Userの全遠足結果を取得
  def index
    @ensokus = current_user.ensokus.all
  end

  # 選択結果の作成画面
  def new; end

  # セッション情報から遠足を新規作成
  def create
    # トランザクションをかけてensokuとbasketを一括保存
    ActiveRecord::Base.transaction do
      # 例外が発生するかもしれない処理
      # ensokuを作成し保存
      # ensokuに紐づくoyatsuをbasketに保存
    end
      # 例外が発生しなかった場合の処理
    # redirect_to oyatsus_path, success: t('.success')
    rescue => e
      # 例外が発生した場合の処理
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

  def ensoku_params
    params.require(:ensoku).permit(:comment, :status)
  end
end
