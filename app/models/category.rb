class Category < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: false
  has_many :products
end
