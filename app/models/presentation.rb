class Presentation < ApplicationRecord
  belongs_to :item, :foreign_key => "item_uuid"
  belongs_to :owner, :class_name => "User", :foreign_key => "user_uuid"

  def serializable_hash(options = {})
    result = super(options)
    url =  SN_CONFIG[Rails.env]["presentation_host"]
    url = File.join(url, self.root_path) if self.root_path
    url = File.join(url, self.relative_path) if self.relative_path
    result[:url] = url
    result
  end

  def random_token
    token_length = 8
    self.root_path = loop do
      range = [*'0'..'9', *'a'..'z', *'A'..'Z']
      random_token = token_length.times.map { (range).sample }.join
      break random_token unless self.class.exists?(root_path: random_token)
    end
  end

  def slug_for_property_and_name(property, name)
    name = name.parameterize
    count = Presentation.where("#{property.to_s} REGEXP '^#{name}(-[0-9]*)?$'").count
    if count == 0
      return name
    else
      while true do
        slug = name + '-' + count.to_s
        if Presentation.where(property => slug).count == 0
          return slug
        end
        count += 1
      end
    end
  end

  def set_root_path_from_name(name)
    name = name.parameterize
    count = Presentation.where("root_path REGEXP '^#{name}(-[0-9]*)?$'").count
    if count == 0
      return self.root_path = name
    else
      while true do
        slug = name + '-' + count.to_s
        if Presentation.where(:root_path => slug).count == 0
          return self.root_path = slug
        end
        count += 1
      end
    end
  end
end
