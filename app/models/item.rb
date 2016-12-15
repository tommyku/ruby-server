class Item < ApplicationRecord
  attr_accessor :rendered_content

  belongs_to :user, optional: true

  has_one :presentation, :foreign_key => "item_uuid", dependent: :destroy

  def references
    Reference.where("source_uuid = ? OR referenced_uuid = ?", self.uuid, self.uuid)
  end

  def serializable_hash(options = {})
    super(options.merge({only: ["uuid", "loc_eek", "content", "content_type", "created_at", "modified_at"]}))
  end

  def value_for_content_key(key)
    JSON.parse(self.content)[key]
  end

end
