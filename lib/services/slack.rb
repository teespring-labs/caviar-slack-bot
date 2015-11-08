require 'net/http'

class SlackClient
  attr_reader :base_url, :slack_url

  def initialize(slack_url:, base_url:)
    @slack_url = slack_url
    @base_url = base_url
  end

  def alert(text)
    uri = URI(slack_url)
    message = "<!here> #{text}"
    icon_url = "#{base_url}/logo.jpg"

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.body = { text: message, username: "Caviar", icon_url: icon_url }.to_json

    https.request(req)

    puts "Posting message to Slack channel: #{message}"
  end
end
