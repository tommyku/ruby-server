class User < ApplicationRecord

  has_many :items, -> { order 'created_at desc' }, :foreign_key => "user_uuid"

  def serializable_hash(options = {})
    result = super(options.merge({only: ["email", "uuid"]}))
    result
  end
  
end
