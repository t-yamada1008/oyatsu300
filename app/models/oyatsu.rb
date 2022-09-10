# おやつモデル
class Oyatsu < ApplicationRecord
  mount_uploader :oyatsu_image, OyatsuImageUploader
  include Scraping::Yaokin

  has_many :baskets
  has_many :oyatsu_baksets, through: :baskets, source: :ensoku
  has_many :reviews

  validates :name, presence: true, length: { maximum: 100 }
  validates :price, presence: true, numericality: { only_integer: true }

  scope :price_over50, -> { where(price: 50..) }
  scope :price_over100, -> { where(price: 100..) }
  scope :price_over150, -> { where(price: 150..) }
  scope :price_over200, -> { where(price: 200..) }
  scope :price_over250, -> { where(price: 250..) }
  scope :price_under50, -> { where(price: ..50) }
  scope :price_under100, -> { where(price: ..100) }
  scope :price_under150, -> { where(price: ..150) }
  scope :price_under200, -> { where(price: ..200) }
  scope :price_under250, -> { where(price: ..250) }

  SCOPES_FOR_PRICE_OVER = %w[price_over50 price_over100 price_over150 price_over200 price_over250].freeze
  SCOPES_FOR_PRICE_UNDER = %w[price_under50 price_under100 price_under150 price_under200 price_under250].freeze

  scope :for_price_over, -> (scope_name) do
    # 無関係なscopeを指定された場合はエラーとする（セキュリティ対策）
    raise ArgumentError unless scope_name.in?(SCOPES_FOR_PRICE_OVER)

    # メタプログラミング（リフレクション）でscopeを呼び出す
    send(scope_name)
  end

  scope :for_price_under, -> (scope_name) do
    # 無関係なscopeを指定された場合はエラーとする（セキュリティ対策）
    raise ArgumentError unless scope_name.in?(SCOPES_FOR_PRICE_UNDER)

    # メタプログラミング（リフレクション）でscopeを呼び出す
    send(scope_name)
  end

  # ransackと連携可能なscopeとする
  def self.ransackable_scopes(_auth_object = nil)
    %i[for_price_over for_price_under]
  end

  def current_user_review(user)
    reviews.find_by(user_id: user.id)
  end
end
