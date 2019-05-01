class User < ApplicationRecord
  has_secure_password

  # presence: 必須のデータがちゃんと入っているか
  validates :name, presence: true
  # uniqueness: データが一意になっているか
  validates :email, presence: true, uniqueness: true
end
