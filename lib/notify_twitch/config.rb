require "fileutils"
require "json"
class NotifyTwitch::Config
	attr_reader :client_id,:username
	def initialize
		if File.file? "#{ENV['HOME']}/.config/notify-twitch/config.json"
			config = JSON.parse File.read("#{ENV['HOME']}/.config/notify-twitch/config.json")
			@client_id = config["client-id"]
			@username = config["username"]
		else
			puts "Can't find your config :(. Don't Worry I'll make you a new one!"
			puts "Enter your client-id. Can be found at your twitch apps dashboard"
			@client_id = gets.chomp
			puts "Enter your usename"
			@username = gets.chomp
			FileUtils.mkdir_p "#{ENV['HOME']}/.config/notify-twitch" unless File.exists? "#{ENV['HOME']}/.config/notify-twitch"
			File.open("#{ENV['HOME']}/.config/notify-twitch/config.json","w") do |f| 
				f << JSON.pretty_generate({"client-id" => @client_id,"username" => @username})
			end
		end
	end
end
			
