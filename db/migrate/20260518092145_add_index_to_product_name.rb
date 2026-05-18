class AddIndexToProductName < ActiveRecord::Migration[8.1]
  def change
    add_index :products, :name
  end
end
