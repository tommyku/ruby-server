class Reference < ApplicationRecord
  belongs_to :source_item, :foreign_key => "source_uuid", :class_name => "Item"
  belongs_to :referenced_item, :foreign_key => "referenced_uuid", :class_name => "Item"
end
