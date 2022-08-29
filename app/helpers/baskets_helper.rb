# basket_controllerで使うview表示系メソッド
module BasketsHelper
  # 対象のおやつがセッションに入っているか
  def in_the_session?(oyatsu)
    session[:oyatsus].find { |f| f[:oyatsu_id] == oyatsu.id }.present? if session[:oyatsus].present?
  end

  # 対象のおやつの個数をセッションから取り出す
  def quantitiy_of_oyatsu(oyatsu)
    targeted_oyatsu = session[:oyatsus].find { |f| f[:oyatsu_id] == oyatsu.id }
    targeted_oyatsu[:quantitiy] if targeted_oyatsu.present?
  end
end
