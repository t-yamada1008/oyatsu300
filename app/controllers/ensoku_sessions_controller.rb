class EnsokuSessionsController < ApplicationController
  # top画面
  # 新規遠足作成のボタンを置く
  def new; end

  # 新規遠足作成
  # ログインしない場合のためにsessionを利用
  def create
    # ensoku_contorllerでオブジェクトを作らずに、セッションを初期化するのみに留める
    # 新しく始めるというボタンを押したらセッションをクリアする。
    session[:oyatsus].clear if session[:oyatsus].present?
    session[:oyatsus] = []
    session[:purse] = 300
    redirect_to oyatsus_path
  end
end
