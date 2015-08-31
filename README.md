Caviar Slack Bot
================

What it does
------------
[Caviar](http://trycaviar.com) is food delivery service used by many startups to deliver dinner to employees. [Slack](http://www.slack.com) is a popular chat program used by many startups. Caviar requires a contact number to send text message updates to, but that contact may change day-to-day. The Caviar Slack bot listens to text messages from Caviar and alerts one your company's Slack channels (or users) whenever updates are sent. It also sends a voice recording to the Caviar delivery person in the rare event that they call the contact number belonging to the bot.

Teespring made a Slack bot, because we're all about automation. You too can run a copy of this bot and automate your dinner process.

Setup
-----
1. [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)
1. Get an account with [Twilio](http://www.twilio.com). You'll probably want to add money to the account so that the voice messaging system feature works properly.
1. Get a Twilio phone number. Doesn't matter what it is. Write this number down.
1. Manage this number in the Twilio web UI. Add two HTTP POST webhooks, one for voice, one for SMS:
  Voice: http://[YOUR_HEROKU_APP_NAME].herokuapp.com/voice set to HTTP POST
  SMS: HTTP http://[YOUR_HEROKU_APP_NAME].herokuapp.com/sms set to HTTP POST
1. Add a new Slack webhook so the bot can notify your channel:
  Go to https://YOUR_SLACK_DOMAIN.slack.com/services/new/incoming-webhook
  Pick a channel or user that you want to be notified of Caviar updates and click "Add Incoming Webhooks Integration".
1. Copy that Webhook URL. You'll need it for the next step.
1. Add that webhook to your Heroky app with `heroku config:add SLACK_URL=[YOUR_WEBHOOK_URL] -a [YOUR_HEROKU_APP_NAME]`
1. Go to http://[YOUR_APP_NAME].herokuapp.com/ and make sure it says OK.
1. Text your Twilio number and make sure it posts to your Slack channel.
1. Call your Twilio number and make sure it gives you a voice response and posts to your Slack channel.
1. Make your Caviar contact number your Twilio phone number.
1. Order food and wait for the bot to keep you up to date!
