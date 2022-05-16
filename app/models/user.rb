class User < ApplicationRecord
  has_many :baskets

  validates :name, presence: true, length: { maximum: 128 }
  validates :comment, length: { maximum: 65_535 }
end
