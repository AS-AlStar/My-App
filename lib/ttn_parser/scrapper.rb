module TtnParser
  class Scrapper

    include Parsable

    def call
      main_categories.map { |category| process_category(site_category: category) }.each(&:join)
    end

    private

    def main_category_urls
      @main_category_urls ||= doc.xpath('//ul[@id="menu-departments-menu"]/li/a/@href').map do |node|
        SITE_DOMAIN + node.text.strip
      end
    end

    def main_categories
      @main_categories = main_category_urls.map do |category_url|
        Category.new(url: category_url)
      end
    end

    def url
      SITE_DOMAIN
    end

    def process_category(site_category:, parent_id: nil)
      Thread.new do
        category = ::Category.find_or_create_by(site_category.to_h.merge(parent_id: parent_id).compact)
        site_category.products.each do |site_product|
          product = ::Product.find_or_create_by(site_product.to_h)
          CategoryProduct.find_or_create_by(product_id: product.id, category_id: category.id)
        end
        site_category.subcategories.each do |subcategory|
          process_category(site_category: subcategory, parent_id: category.id)
        end
      end
    end
  end
end