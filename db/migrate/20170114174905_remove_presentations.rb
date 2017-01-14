class RemovePresentations < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :presentation_name
    remove_column :users, :username
  end
end
