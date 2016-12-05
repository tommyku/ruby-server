class RenameSnippets < ActiveRecord::Migration[5.0]
  def change
    rename_table :snippets, :notes
    rename_table :categories, :groups
  end
end
