class Category < ApplicationRecord
  has_many :category_products, dependent: :destroy
  has_many :products, through: :category_products
  has_many :subcategories, class_name: 'Category', foreign_key: :parent_id

  belongs_to :parent, class_name: 'Category', optional: true

  PRODUCTS_PER_PAGE = 40



  def ancestors
    ancestors = []
    current_parent = parent
    while current_parent
      ancestors.unshift(current_parent)
      current_parent = current_parent.parent
    end
    ancestors
  end

  def products?
    products.any?
  end
end
