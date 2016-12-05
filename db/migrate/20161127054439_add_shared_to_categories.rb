class AddSharedToCategories < ActiveRecord::Migration
  def change
    change_table(:snippets) do |t|
      t.boolean :shared_via_group, :default => false
    end
  end
end
