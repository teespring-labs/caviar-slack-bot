require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

class Server < Sinatra::Application
  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def slack_url
      ENV["SLACK_URL"]
    end
  end

  def alert_slack(text)
    uri = URI(slack_url)
    message = "@here #{text}"
    icon_url = "#{base_url}/logo.jpg"

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req.body = { text: message, username: "Caviar", icon_url: icon_url }.to_json

    https.request(req)

    puts "Posting message to Slack channel: #{message}"
  end

  get '/' do
    puts "Heartbeat 200 OK"
    "OK"
  end

  post '/sms' do
    puts "Received Twilio SMS: #{params.to_s}"
    alert_slack(params[:Body])
  end

  post '/voice' do
    puts "Received Twilio Voice: #{params.to_s}"

    response = Twilio::TwiML::Response.new { |r|
      r.Say "Hello, Caviar driver. I am an automated answering system, but someone will call you back at this number shortly. You can also send text messages to this phone number and someone will read them."
    }.text

    alert_slack("The Caviar driver called the contact number. Please return their call at #{params[:From]}. Thanks!")

    response
  end
end
