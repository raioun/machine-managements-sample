class Storage < ApplicationRecord
  belongs_to :company
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :address, length: { maximum: 100 }
  
  has_many :rental_machines
  has_many :machines, through: :rental_machines
  has_many :branches, through: :rental_machines
  
  def storage_full_name
    self.company.name + '/' + self.name
  end
end
