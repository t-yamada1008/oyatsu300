class User < ApplicationRecord
  has_many :baskets

  validates :comment, length: { maximum: 65_535 }
end
