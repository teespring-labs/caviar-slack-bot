require File.expand_path('../../services/slack', __FILE__)
require 'date'

namespace :slack do
  desc 'Reminder for Caviar deadline'
  task :reminder do
    time = Time.now.getlocal("-08:00")
    unless time.saturday? || time.sunday?
      client = SlackClient.new(slack_url: ENV["SLACK_URL"], base_url: ENV["BASE_URL"])
      client.alert("Caviar orders close in 30 minutes. Please find the menu and order here: https://team.teespring.com/blogs/sfmenu")
    end
  end
end
