class Product < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products

  scope :ordered_by_price_up, -> { order(price: :desc) }
  scope :ordered_by_price_down, -> { order(:price) }
  scope :by_category, ->(category) { where(id: CategoryProduct.where(category_id: category.id).pluck(:id)) }
end
