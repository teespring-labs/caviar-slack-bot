require File.expand_path('../../services/slack', __FILE__)
require 'date'

# this is invoked by the Heroku Scheduler addon
# `rake slack:reminder FIRST_REMINDER=true` for the first alert
# and `rake slack:reminder` for the second
namespace :slack do
  desc 'Reminder for Caviar deadline'
  task :reminder do
    time = Time.now.getlocal("-08:00")
    unless time.saturday? || time.sunday?
      client = SlackClient.new(slack_url: ENV["SLACK_URL"], base_url: ENV["BASE_URL"])
      time_remaining = (ENV['FIRST_REMINDER'] == 'true') ? '90 minutes' : '30 minutes'
      client.alert("Caviar orders close in #{time_remaining}. Please find the menu in the latest weekly lunch email and order!")
    end
  end
end
