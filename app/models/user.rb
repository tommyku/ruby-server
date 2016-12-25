class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :items, -> { order 'created_at desc' }, :foreign_key => "user_uuid"

  def jwt
    JWTWrapper.encode({:user_uuid => self.uuid})
  end

  def serializable_hash(options = {})
    result = super(options)
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

end
