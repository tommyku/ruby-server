template = ERB.new File.new("#{Rails.root}/config/standard_notes.yml").read
SN_CONFIG = YAML.load template.result(binding)
# Single user mode is the default mode if you're hosting on your own server for personal use.
# If you want to allow anonymous registration on your server and allow strangers to save to their own accounts,
# you can set this value to false.
if SN_CONFIG[Rails.env].key?("single_user_mode")
  Rails.application.config.x.single_user_mode = SN_CONFIG[Rails.env]["single_user_mode"]
else
  Rails.application.config.x.single_user_mode = true
end
