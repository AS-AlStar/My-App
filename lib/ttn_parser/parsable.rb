require 'open-uri'

module TtnParser
  module Parsable

    private

    def doc
      @doc ||= Nokogiri::HTML(open(url))
    end
  end
end
