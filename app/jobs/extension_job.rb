class ExtensionJob < ApplicationJob
  include ActiveJobRetriesCount

  queue_as :default

  def perform(url, items)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
    req.body = {:items => items}.to_json
    http.use_ssl = (uri.scheme == "https")
    response = http.request(req)

    if response.code != '200'
      retry_job wait: 5.seconds if retries_count < 5
    end
  end
end
