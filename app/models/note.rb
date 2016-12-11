class Note < ApplicationRecord
  attr_accessor :rendered_content

  belongs_to :user, optional: true
  belongs_to :group, optional: true
  has_one :presentation, as: :presentable, dependent: :destroy

  accepts_nested_attributes_for :presentation

  attr_encrypted :content, key: ENV['NOTE_CONTENT_EK'], prefix: 'encrypted_'
  attr_encrypted :name, key: ENV['NOTE_NAME_EK'], prefix: 'encrypted_'
  # attr_encrypted :content, key: ENV['NOTE_CONTENT_EK'], prefix: 'enc_'
  attr_encrypted :loc_enc_content, key: ENV['NOTE_LOCAL_CONTENT_EK'], prefix: 'enc_'
  attr_encrypted :local_encrypted_content, key: ENV['NOTE_LOCAL_CONTENT_EK'], prefix: 'encrypted_'

  def serializable_hash(options = {})
    result = super(options.merge({only: ["id", "uuid", "loc_eek", "group_id", "created_at", "modified_at"]}))
    result["content"] = self.content
    result["loc_enc_content"] = self.loc_enc_content
    result["local_encrypted_content"] = self.local_encrypted_content
    result["local_eek"] = self.local_eek
    result["title"] = self.name
    result
  end

  def title
    JSON.parse(self.content)["title"]
  end

  def text
    JSON.parse(self.content)["text"]
  end
end
