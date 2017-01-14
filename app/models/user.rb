class User < ApplicationRecord

  has_many :items, -> { order 'created_at desc' }, :foreign_key => "user_uuid"

  def jwt
    JWTWrapper.encode({:user_uuid => self.uuid})
  end

  def serializable_hash(options = {})
    result = super(options.merge({only: ["email", "uuid"]}))
    result
  end

  DEFAULT_COST = 11

  def self.hash_password(password)
    BCrypt::Password.create(password, cost: DEFAULT_COST).to_s
  end

  def self.test_password(password, hash)
    bcrypt = BCrypt::Password.new(hash)
    password = BCrypt::Engine.hash_secret(password, bcrypt.salt)
    return password == hash
  end

end
