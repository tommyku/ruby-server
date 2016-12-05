class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :name
      t.text :content

      # local encryption
      t.text :local_encrypted_content
      t.string :local_eek
      t.string :local_encryption_scheme

      #
      # server side encryption
      #

      # double encrypt locally encrypted content
      t.text :encrypted_local_encrypted_content
      t.string :encrypted_local_encrypted_content_iv

      t.text :encrypted_content
      t.string :encrypted_content_iv

      t.string :encrypted_name
      t.string :encrypted_name_iv

      t.belongs_to :category
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
