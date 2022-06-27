class Ensoku < ApplicationRecord
  belongs_to :user
  validates :purse, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 300
  }
  validates :comment, length: { maximum: 65_535 }
end
