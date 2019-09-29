class Machine < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :type1, length: { maximum: 50 }
  validates :type2, length: { maximum: 50 }
  
  has_many :rental_machines
  has_many :branches, through: :rental_machines
  has_many :storages, through: :rental_machines
  
  def machine_full_name
    self.name + '/' + self.type1 + '/' + self.type2
  end
end
