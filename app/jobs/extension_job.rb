class ExtensionJob < ApplicationJob
  queue_as :default

  def perform(url, items)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    req.body = {:items => items}.to_json
    http.use_ssl = (uri.scheme == "https")
    response = http.request(req)
  end
end
