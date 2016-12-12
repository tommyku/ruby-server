class AddUuidToModels < ActiveRecord::Migration[5.0]
  def change
    add_column :notes, :uuid, :string
    add_column :groups, :uuid, :string
    add_column :presentations, :uuid, :string

    require 'securerandom'

    Group.all.each do |group|
      if !group.uuid
        group.uuid = SecureRandom.uuid
        group.save
      end
    end

    Note.all.each do |note|
      if !note.uuid
        note.uuid = SecureRandom.uuid
        note.save
      end
    end

    Presentation.all.each do |presentation|
      if !presentation.uuid
        presentation.uuid = SecureRandom.uuid
        presentation.save
      end
    end

  end
end
