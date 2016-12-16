module Presentable
  def self.included(base)

  end

  def presentation_url
    url =  SN_CONFIG[Rails.env]["presentation_host"]
    if Rails.configuration.x.single_user_mode
      url = File.join(url, self.presentation_name)
    else
      url = File.join(url, self.user.username);
      url = File.join(url, self.presentation_name)
    end
    return url
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
    count = Item.where("#{property.to_s} REGEXP '^#{name}(-[0-9]*)?$'").count
    if count == 0
      return name
    else
      while true do
        slug = name + '-' + count.to_s
        if Item.where(property => slug).count == 0
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
