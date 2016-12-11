template = ERB.new File.new("#{Rails.root}/config/neeto.yml").read
NEETO_CONFIG = YAML.load template.result(binding)
# Single user mode is the default mode if you're hosting on your own server for personal use.
# If you want to allow anonymous registration on your server and allow strangers to save to their own accounts,
# you can set this value to false.
if NEETO_CONFIG[Rails.env].key?("single_user_mode")
  Rails.application.config.x.neeto.single_user_mode = NEETO_CONFIG[Rails.env]["single_user_mode"]
else
  Rails.application.config.x.neeto.single_user_mode = true
end
