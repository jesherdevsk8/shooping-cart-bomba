class Product < ApplicationRecord
  has_many :items, class_name: 'CartItem', dependent: :destroy
  has_many :carts, through: :items

  validates_presence_of :name, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
