class RenameForeignKeys < ActiveRecord::Migration[5.0]
  def change
    rename_column :notes, :category_id, :group_id

    Presentation.all.each do |presentation|
      case presentation.presentable_type
      when "Snippet"
        presentation.presentable_type = "Note"
      when "Category"
        presentation.presentable_type = "Group"
      end

      presentation.save
    end
  end
end
