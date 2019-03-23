module TtnParser
  class Product
    include Parsable

    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def title
      @title ||= value_by_xpath('//h1[contains(@class, "product_title")]', &:text)
    end

    def image
      @image ||= value_by_xpath('//div[@class="techmarket-single-product-gallery-thumbnails"]//figure/img/@src') do |node|
        SITE_DOMAIN + node.text
      end
    end

    def price
      @price ||= value_by_xpath('//p[@class="price"]/span') { |node| node.text.strip.to_f }
    end

    def description
      @description ||= values_by_xpath('//div[@class="woocommerce-product-details__short-description"]//li', &:text).join(';')
    end

    def to_h
      {
          title: title,
          image: image,
          price: price,
          description: description,
          url: url
      }
    end
  end
end
