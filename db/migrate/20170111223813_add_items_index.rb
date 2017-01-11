class AddItemsIndex < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :updated_at
  end
end
