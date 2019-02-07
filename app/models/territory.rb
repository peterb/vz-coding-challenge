class Territory < ApplicationRecord
  has_many :emissions
  validates :code,  uniqueness: true
end
