# basket_controllerで使うview表示系メソッド
module BasketsHelper
  # 残金判定メソッド
  def calculation
    user_baskets = current_user.baskets
    oyatsu_sum = []
    user_baskets.each do |ub|
      single_oyatsu_sum = ub.oyatsu.price * ub.quantity
      oyatsu_sum.push single_oyatsu_sum
    end
    current_user.purse = current_user.purse - oyatsu_sum.sum
  end
end
