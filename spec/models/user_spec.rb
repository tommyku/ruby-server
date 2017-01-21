require 'rails_helper'

RSpec.describe User, type: :model do
  context "with a User class" do
    
    it "can hash a password" do
      p = User.hash_password("test")

      expect(p).not_to eql("test")
    end

    it "can check a password hash" do
      p = User.hash_password("test")
      check = User.test_password("test", p)

      expect(check).to eql(true)
    end
  end

  context "with a single user" do
    it "orders items chronologically" do
      u = User.create!
      item1 = u.items.create!
      item2 = u.items.create!
      expect(u.reload.items).to eq([item2, item1])
    end
  end

end
