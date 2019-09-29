class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :orders
  has_many :projects, through: :orders
  has_many :orderers, through: :orders
  has_many :rental_machines, through: :orders
  
  enum status:{在籍中: 0, 退社済み: 1}
end
