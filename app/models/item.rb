class Item < ApplicationRecord
  attr_accessor :rendered_content

  include Presentable

  belongs_to :user, :foreign_key => "user_uuid", optional: true

  def references
    Reference.where("source_uuid = ? OR referenced_uuid = ?", self.uuid, self.uuid)
  end

  def serializable_hash(options = {})
    result = super(options.merge({only: ["uuid", "enc_item_key", "content", "content_type", "auth_hash", "presentation_name", "created_at", "updated_at"]}))
    if self.presentation_name
      result[:presentation_url] = self.presentation_url
    end
    result
  end

  def value_for_content_key(key)
    puts self.content
    base64content = self.content[3, self.content.length]
    puts base64content
    json_string = Base64.decode64(base64content)
    puts json_string
    JSON.parse(json_string)[key]
  end

end
