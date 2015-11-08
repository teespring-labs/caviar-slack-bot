require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

require File.expand_path('../lib/services/slack', __FILE__)

class Server < Sinatra::Application
  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def slack_url
      @slack_url ||= ENV["SLACK_URL"]
    end

    def slack_client
      @slack_client ||= SlackClient.new(slack_url: slack_url, base_url: base_url)
    end
  end

  get '/' do
    puts "Heartbeat 200 OK"
    "OK"
  end

  post '/sms' do
    puts "Received Twilio SMS: #{params.to_s}"
    slack_client.alert(params[:Body])
  end

  post '/voice' do
    puts "Received Twilio Voice: #{params.to_s}"

    response = Twilio::TwiML::Response.new { |r|
      r.Say "Hello, Caviar driver. I am an automated answering system, but someone will call you back at this number shortly. You can also send text messages to this phone number and someone will read them."
    }.text

    slack_client.alert("The Caviar driver called the contact number. Please return their call at #{params[:From]}. Thanks!")

    response
  end
end
