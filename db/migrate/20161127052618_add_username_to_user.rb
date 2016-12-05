class AddUsernameToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :username, :unique => true
    end
  end
end
