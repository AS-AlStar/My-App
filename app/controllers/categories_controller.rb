class CategoriesController < ApplicationController
  PRODUCTS_PER_PAGE = 40

  def show
    @category = Category.find(params[:id])
    @products = Product.by_category(@category)
    @pages_count = (@products.count / PRODUCTS_PER_PAGE.to_f).ceil.to_i
    @current_page = params[:page] ? params[:page].to_i : 1
    @order_type = params[:order]
   if params[:page] && params[:order]
      case params[:order]
      when 'expensive'
        @products = @products.ordered_by_price_up
      when 'cheap'
        @products = @products.ordered_by_price_down
      end
     @products = @products.limit(PRODUCTS_PER_PAGE).offset(params[:page].to_i * PRODUCTS_PER_PAGE)
   elsif params[:page]
     @products = @products.limit(PRODUCTS_PER_PAGE).offset(params[:page].to_i * PRODUCTS_PER_PAGE)
   elsif  params[:order]
     case params[:order]
     when 'expensive'
       @products = @products.ordered_by_price_up
     when 'cheap'
       @products = @products.ordered_by_price_down
     end
     @products = @products.limit(PRODUCTS_PER_PAGE).offset(0)
   else
     @products = @products.limit(PRODUCTS_PER_PAGE).offset(0)
   end
  end

  def index
    @categories = Category.top_level
  end

end
