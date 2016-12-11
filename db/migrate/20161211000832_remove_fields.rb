class RemoveFields < ActiveRecord::Migration[5.0]
  def change
    change_table(:users) do |t|
      remove_index :users, [:uid, :provider]
      remove_column :users, :provider
      remove_column :users, :uid
      remove_column :users, :tokens
    end
  end
end
