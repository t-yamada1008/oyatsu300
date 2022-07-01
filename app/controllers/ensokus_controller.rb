class EnsokusController < ApplicationController
  before_action :require_login

  # 遠足一覧画面
  # Userの全遠足結果を取得
  def index
    @ensokus = current_user.ensokus.all
  end

  # ログイン後のtop画面
  # 新規遠足作成のボタンを置く
  def new; end

  # 新規遠足作成
  def create
    @ensoku = current_user.ensokus.create
    redirect_to choose_oyatsu_path(ensoku: @ensoku)
  end
end
