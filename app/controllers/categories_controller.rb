class CategoriesController < ApplicationController
  PRODUCTS_PER_PAGE = 40

  def show
    @category = Category.find(params[:id])
    @products = @category.products
    if params[:order]
      sorted_by_price = @products.sort_by(&:price)
      @products = params[:order] == 'expensive' ? sorted_by_price.reverse : sorted_by_price
    end

    page = params[:page] ? params[:page].to_i : 1

    start_index = (page - 1) * PRODUCTS_PER_PAGE
    end_index = page * PRODUCTS_PER_PAGE
    @products = @products[start_index...end_index]

  end
end
