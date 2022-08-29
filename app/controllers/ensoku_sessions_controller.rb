class EnsokuSessionsController < ApplicationController
  # createでのsession利用時にCSRF保護で弾かれるため追加
  protect_from_forgery

  # top画面
  # 新規遠足作成のボタンを置く
  def new; end

  # 新規遠足作成
  # ログインしない場合のためにsessionを利用
  def create
    # ensoku_contorllerでオブジェクトを作らずに、セッションを初期化するのみに留める
    # 新しく始めるというボタンを押したらセッションをクリアする。
    session[:oyatsus].clear if session[:oyatsus].present?
    session[:ensoku].clear if session[:ensoku].present?
    session[:oyatsus] = []
    session[:purse] = 300
    redirect_to oyatsus_path
  end
end
