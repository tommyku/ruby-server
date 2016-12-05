class Presentation < ApplicationRecord
  belongs_to :presentable, polymorphic: true
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  validates :root_path, uniqueness: true, :allow_nil => true, :allow_blank => true

  def serializable_hash(options = {})
    result = super(options)
    url =  NEETO_CONFIG[Rails.env]["presentation_host"]
    url += self.root_path if self.root_path
    url += self.parent_path + "/" + self.relative_path if self.relative_path
    result[:url] = url
    result
  end

  def set_random_root_path
    token_length = 8
    self.root_path = loop do
      range = [*'0'..'9', *'a'..'z', *'A'..'Z']
      random_token = token_length.times.map { (range).sample }.join
      break random_token unless self.class.exists?(root_path: random_token)
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
