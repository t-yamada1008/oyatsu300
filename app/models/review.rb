class Review < ApplicationRecord
  belongs_to :oyatsu
  belongs_to :user

  validates :comment, length: { minimum: 1, maximum: 65_535 }
end
