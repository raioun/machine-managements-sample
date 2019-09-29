class Company < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  
  has_many :branches
  has_many :storages
end
