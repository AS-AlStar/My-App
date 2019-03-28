module TtnParser
  class Scrapper

    include Parsable

    def call
      while main_categories.any?
        category = main_categories.shift
        process_category(site_category: category)
      end
    end

    def update_image(id)
      product = ::Product.find(id)
      product_url = product.url
      doc_url = Nokogiri::HTML(open(product_url))
      product_image_new_url = doc_url.at_xpath('//div[@class="product"]//figure/div[@data-thumb]//img/@src').text
      product.image = SITE_DOMAIN + product_image_new_url
      product.save!
    end

    def all_update_image
      ::Product.all.each do |product|
        update_image(product.id)
      end
    end

    def save_top_level_categories
      main_categories.each { |category| ::Category.find_or_create_by(category.to_h) }
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
      category = ::Category.find_or_create_by(site_category.to_h.merge(parent_id: parent_id).compact)
      while site_category.products.any?
        site_product = site_category.products.shift
        product = ::Product.find_or_create_by(site_product.to_h)
        CategoryProduct.find_or_create_by(product_id: product.id, category_id: category.id)
      end
      while site_category.subcategories.any?
        subcategory = site_category.subcategories.shift
        process_category(site_category: subcategory, parent_id: category.id)
      end
    end
  end
end