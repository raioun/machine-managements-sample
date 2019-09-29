class Customer < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: {case_sensitive: false }
                   
  has_many :projects
  has_many :orderers
end
