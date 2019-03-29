require 'csv'

module TtnParser
class Reporter

  def database_to_csv
    CSV.open("data.csv","w") do |rw|
      rw << ["breadcrumb", "title", "price", "url", "image"]
      ::Product.find_each(batch_size: 5000) do |product|
        rw << ["#{product.categories.name}", product.title, "#{product.price}", product.url, product.image]
      end
    end
  end

end
end
