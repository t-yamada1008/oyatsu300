class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :ensokus, dependent: :destroy
  has_one :authentication, dependent: :destroy
  accepts_nested_attributes_for :authentication
  has_many :reviews

  validates :name, presence: true, length: { maximum: 128 }
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, length: { minimum: 4, maximum: 16 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  enum role: {
    general: 0,
    admin: 1
  }
end
