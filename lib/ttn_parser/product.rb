module TtnParser
  class Product
    include Parsable

    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def title
      @title ||= doc.at_xpath('//h1[contains(@class, "product_title")]')&.text
    end

    def image
      @image ||= SITE_DOMAIN + doc.at_xpath('//div[@class="techmarket-single-product-gallery-thumbnails"]//figure/img/@src')&.text
    end

    def price
      @price ||= doc.at_xpath('//p[@class="price"]/span')&.text.strip.to_f
    end

    def description
      @description ||= doc.xpath('//div[@class="woocommerce-product-details__short-description"]//li').map(&:text).join(';')
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
