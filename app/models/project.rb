class Project < ApplicationRecord
  belongs_to :customer
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, length: { maximum: 80 }
  
  has_many :orders
  has_many :orderers, through: :orders
  has_many :rental_machines, through: :orders
  has_many :users, through: :orders

  enum status:{施工中: 0, 施工済み: 1}
  
  def project_full_name
    self.customer.name + '/' + self.name
  end

end
