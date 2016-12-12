class Group < ApplicationRecord
  include Guidable
  
  has_many :notes, -> { order 'created_at desc' }
  has_one :presentation, as: :presentable, dependent: :destroy
end
