class Orderer < ApplicationRecord
  belongs_to :customer
  
  validates :family_name, presence: true, length: { maximum: 10 }
  validates :first_name, length: { maximum: 10 }
  validates :phone_number, length: {maximum: 20 }
  
  has_many :orders
  has_many :projects, through: :orders
  has_many :rental_machines, through: :orders
  has_many :users, through: :orders
  
  enum status:{在籍中: 0, 退社済み: 1}
  
  def orderer_full_name
    self.customer.name + '/' + self.family_name + self.first_name
  end
end
