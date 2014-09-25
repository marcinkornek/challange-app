require 'pusher'

Pusher.app_id = ENV["PUSHER_APP_ID"]
Pusher.key    = ENV["PUSHER_KEY"]
Pusher.secret = ENV["PUSHER_SECRET"]

# Pusher.url = "http://f670af9b96fad62b83ac:caae74f627c9a2d6c93c@api.pusherapp.com/apps/90661"
# Pusher.url = "http://#{ENV["PUSHER_KEY"]}:#{ENV["PUSHER_SECRET"]}@api.pusherapp.com/apps/#{ENV["PUSHER_APP_ID"]}"
# Pusher.logger = Rails.logger

data = {'message' => 'This is an HTML5 Realtime Push Notification!'}
Pusher['my_notifications'].trigger('notification', data)
