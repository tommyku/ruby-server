class Note < ApplicationRecord
  attr_accessor :rendered_content

  include Guidable

  belongs_to :user, optional: true
  belongs_to :group, optional: true
  has_one :presentation, as: :presentable, dependent: :destroy

  attr_encrypted :content, key: ENV['NOTE_CONTENT_EK'], prefix: 'enc_'
  # attr_encrypted :loc_enc_content, key: ENV['NOTE_LOCAL_CONTENT_EK'], prefix: 'enc_'

  def serializable_hash(options = {})
    result = super(options.merge({only: ["id", "uuid", "loc_eek", "group_id", "created_at", "modified_at"]}))
    result["content"] = self.content
    # result["loc_enc_content"] = self.loc_enc_content
    result
  end

  def title
    JSON.parse(self.content)["title"]
  end

  def text
    JSON.parse(self.content)["text"]
  end
end
