module Guidable
  extend ActiveSupport::Concern

  require 'securerandom'

  included do
    before_create :generate_uuid
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
