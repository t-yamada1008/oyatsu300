module EnsokuHelper
  # 遠足のおやつは300円まで
  OKOZUKAI = 300

  def calc_okozukai
    sum = 0
    baskets = @ensoku.baskets
    baskets.each do |basket|
      oyatsu = basket.oyatsu
      sum += oyatsu.price
    end
    OKOZUKAI - sum
  end
end
