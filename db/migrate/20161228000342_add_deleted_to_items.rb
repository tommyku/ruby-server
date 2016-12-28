class AddDeletedToItems < ActiveRecord::Migration[5.0]
  def change
    change_table(:items) do |t|
      t.boolean :deleted, :default => false
    end
  end
end
