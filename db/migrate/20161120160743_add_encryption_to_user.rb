class AddEncryptionToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.boolean :local_encryption_enabled
    end
  end
end
