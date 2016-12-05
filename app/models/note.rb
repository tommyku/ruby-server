class Note < ApplicationRecord
  attr_accessor :rendered_content

  belongs_to :user, optional: true
  belongs_to :group, optional: true
  has_one :presentation, as: :presentable, dependent: :destroy

  accepts_nested_attributes_for :presentation

  attr_encrypted :name, key: ENV['NOTE_NAME_EK']
  attr_encrypted :content, key: ENV['NOTE_CONTENT_EK']
  attr_encrypted :local_encrypted_content, key: ENV['NOTE_LOCAL_CONTENT_EK']
end
