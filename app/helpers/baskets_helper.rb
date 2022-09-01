# basket_controllerで使うview表示系メソッド
module BasketsHelper
  # 対象のおやつがセッションに入っているか
  def in_the_session?(oyatsu)
    session[:oyatsus].find { |f| f[:oyatsu_id] == oyatsu.id }.present? if session[:oyatsus].present?
  end

  # セッション内部の該当おやつの数を取得
  def quantity_oyatsu_session(oyatsu)
    targeted_oyatsu = session[:oyatsus].find { |f| f[:oyatsu_id] == oyatsu.id }
    targeted_oyatsu[:quantity] if targeted_oyatsu.present?
  end

  # 遠足インスタンス内部の該当おやつの数を取得
  def quantity_oyatsu_ensoku(oyatsu)
    @ensoku.baskets.find_by(oyatsu_id: oyatsu.id).quantity if check_ensoku?(oyatsu)
  end

  # 遠足インスタンスの存在チェック
  def check_ensoku?(oyatsu)
    @ensoku.present? && @ensoku.baskets.find_by(oyatsu_id: oyatsu.id).present?
  end
end
