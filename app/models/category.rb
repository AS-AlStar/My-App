class Category < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products
  has_many :subcategories, class_name: 'Category', foreign_key: :parent_id
  
  belongs_to :parent, class_name: 'Category', optional: true
end
