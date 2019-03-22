class AddColumsToCategory < ActiveRecord::Migration[5.2]
  def change
    add_reference :categories, :parent, index: true
  end
end
