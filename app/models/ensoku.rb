class Ensoku < ApplicationRecord
  has_many :basket
  belongs_to :user
  validates :purse, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 300
  }
  validates :comment, length: { maximum: 65_535 }
  validates :comment, length: { maximum: 65_535 }

  enum status: {
    selecting: 0,
    colse: 1,
    open: 2
  }
end
