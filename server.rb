require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
require 'net/http'
require 'uri'
require 'json'
require File.expand_path('../lib/services/slack', __FILE__)

account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTH_TOKEN']

@client = Twilio::REST::Client.new account_sid, auth_token

class Server < Sinatra::Application

  SIX_HOURS = 60 * 60 * 6

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

  post '/text' do
    unless @from && (Time.now - @time) > SIX_HOURS
      slack_client.alert("Sorry, I don't have the driver's number yet!") and return
    end

    @client.messages.create(
      from: "+#{ENV['CAVIAR_PHONE_NUMBER']}",
      to: @from,
      body: params[:text]
    )
  end

  post '/sms' do
    puts "Received Twilio SMS: #{params.to_s}"

    @from = params[:From]
    @time = Time.now

    slack_client.alert("#{params[:Body]} - Respond to this text using @caviar.")
  end

  post '/voice' do
    puts "Received Twilio Voice: #{params.to_s}"

    response = Twilio::TwiML::Response.new { |r|
      r.Say "Hello, Caviar driver. I am an automated answering system, but someone will call you back at this number shortly. You can also send text messages to this phone number and someone will read them."
    }.text

    @from = params[:From]
    @time = Time.now

    slack_client.alert("The Caviar driver called the contact number. Please return their call at #{@from}. You can also send them a text by using @caviar. Thanks!")

    response
  end
end
