class User < ApplicationRecord

  has_many :items, -> { order 'created_at desc' }, :foreign_key => "user_uuid"
  validates_uniqueness_of :username, :allow_blank => true, :allow_nil => true

  def jwt
    JWTWrapper.encode({:user_uuid => self.uuid})
  end

  def serializable_hash(options = {})
    result = super(options.merge({only: ["email", "username", "uuid"]}))
    result[:single_user_mode] = Rails.configuration.x.single_user_mode
    result
  end

  def set_random_username
    token_length = 8
    self.username = loop do
      range = [*'0'..'9', *'a'..'z', *'A'..'Z']
      random_token = token_length.times.map { (range).sample }.join
      break random_token unless self.class.exists?(username: random_token)
    end
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
