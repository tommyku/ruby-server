class Item < ApplicationRecord

  belongs_to :user, :foreign_key => "user_uuid", optional: true

  def serializable_hash(options = {})
    result = super(options.merge({only: ["uuid", "enc_item_key", "content", "content_type", "auth_hash", "deleted", "created_at", "updated_at"]}))
    result
  end

end
