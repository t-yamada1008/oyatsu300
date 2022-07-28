class Ensoku < ApplicationRecord
  has_many :baskets, dependent: :destroy
  belongs_to :user, optional: true
  has_many :basket_oyatsus, through: :baskets, source: :oyatsu

  validates :purse, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 300
  }
  validates :comment, length: { maximum: 65_535 }

  enum status: {
    selecting: 0,
    close: 1,
    open: 2
  }

  OKOZUKAI = 300

  # 遠足に紐づくバスケットに指定したおやつを入れる
  def basket_in(oyatsu)
    # おこづかいよりおやつの値段が少なかったらfalse
    basket_oyatsus << oyatsu
  end

  # 遠足に紐づくバスケットに指定したおやつが入っているか
  def basket_oyatsu_exists?(oyatsu)
    baskets.where(oyatsu_id: oyatsu).exists?
  end

  # 遠足に紐づくバスケットから指定したおやつのデータを一つ取得する
  # バスケットからおやつを削除するとき用
  def basket_find(oyatsu)
    baskets.find_by(oyatsu_id: oyatsu)
  end

  # 遠足に紐づくバスケットの合計金額を取得
  def basket_price_sum
    arr = []
    basket_oyatsus.each do |bo|
      arr.push bo.price
    end
    arr.sum
  end

  # 遠足に紐づくバスケットのおかしの種類をまとめたものを取得
  def basket_oyatsus_group
    basket_oyatsus.group(:id)
  end

  # おこずかいが0以下になるかチェック
  def purse_under_zero?
    purse.negative? || purse.zero?
  end

  # おこずかいを更新
  def update_purse
    result = OKOZUKAI - basket_price_sum
    update(purse: result)
  end
end
