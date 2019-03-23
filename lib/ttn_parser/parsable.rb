require 'open-uri'

module TtnParser
  module Parsable

    private

    def doc
      @doc ||= Nokogiri::HTML(open(url))
    end

    def values_by_xpath(xpath, &block)
      nodes = doc.xpath(xpath)
      block_given? ? nodes.map(&block) : nodes
    rescue
      []
    end

    def value_by_xpath(xpath)
      node = doc.at_xpath(xpath)
      block_given? ? yield(node) : node
    rescue
      nil
    end
  end
end
