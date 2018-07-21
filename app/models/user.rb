class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50, minimum: 4 }
  validates :email, presence: true, length: { maximum: 255 }
end
