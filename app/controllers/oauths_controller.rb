class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path, info: t('.login_cancel', item: provider.titleize)
      return
    end
    # reset_sessionが挟まるため、先に残したいsession情報を格納する
    @ensoku = session[:ensoku] if session[:ensoku].present?
    create_user_from(provider) unless (@user = login_from(provider))
    # えんそく情報が存在する場合、ensokuにuser_idを追加
    set_ensoku_user if @ensoku.present?
    redirect_to root_path, success: t('.login_success', item: provider.titleize)
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def create_user_from(provider)
    @user = create_from(provider)
    set_ensoku_user if session[:ensoku].present?
    reset_session
    auto_login(@user)
  end

  def set_ensoku_user
    # 遠足のセッション情報が存在する場合、ユーザーと紐付けて登録
    @ensoku.user_id = @user.id
    @ensoku.save!
  end
end
