module TtnParser
  class Category
    include Parsable

    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def name
      @name ||= value_by_xpath('//h1') { |node| node.text.strip }
    end

    def to_h
      { name: name, url: url }
    end

    def subcategories
      @subcategories ||= values_by_xpath('//div[@class="product-loop-categories"]//a/@href') do |node|
        self.class.new(url: SITE_DOMAIN + node.text)
      end
    end

    def products
      @products ||= product_urls.map { |product_url| Product.new(url: product_url) }
    end

    def last_page_number
      @last_page_number ||= values_by_xpath('//a[@class="page-numbers"]/@href').last.text[/page=(\d+)/, 1].to_i rescue 0
    end

    def product_urls
      @product_urls ||= (1..last_page_number).flat_map do |page_number|
        page_url = url + "?page=#{page_number}"
        page_doc = Nokogiri::HTML(open(page_url))
        nodes = page_doc.xpath('//div[@class="products"]//div[contains(@class, "product")]//a/@href')
        nodes.map(&:text).uniq.reject(&:empty?).map { |product_url| SITE_DOMAIN + product_url }
      end
    end
  end
end
