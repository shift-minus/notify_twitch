require "json"
require "net/http"
require "notify_twitch/config"
BASE_API = "https://api.twitch.tv/helix"
module NotifyTwitch
	extend self
	def api_call(location,params)
		config = Config.new
		base = "#{BASE_API}#{location}?"
		params.each do |k,v|
			if base[-1] == "?"
				base << "#{k}=#{v}"
			elsif k.nil? && base[-1] == "?"
				base << v
			elsif k.nil?
				base << "&#{v}"
			else
				base << "&#{k}=#{v}"
			end
		end
		url = URI.parse(base)
		Net::HTTP.start(url.host,url.port,:use_ssl => url.scheme == "https") do |http|
			request = Net::HTTP::Get.new(url)
			request["Client-ID"] = config.client_id
			response = http.request request
			if response.code.to_i < 400 
				JSON.parse response.body
			else
				raise "Bad status code #{response.code} #{response.body}"
			end
		end
	end
	def get_user_id(username)
		api_call("/users",{:login => username})["data"].first["id"]
	end
	def get_user(id)
		api_call("/users",{:id => id})["data"].first
	end
	def get_followers(id)
		followees_ids = []
		url = URI.parse "#{BASE_API}/users/follows?from_id=#{id}&first=100"
		followees = api_call("/users/follows",{:from_id => id, :first => 100})["data"]
		followees.each do |f|
				followees_ids << f["to_id"]
				sleep 1
		end
		followees_ids
	end
	def get_live_followers(username)
		followers_users = []
		id = get_user_id(username)
		followers = get_followers(id).map {|f| "user_id=#{f}"}.join("&")
		api_call("/streams",{:type => "live", :first => 100, nil => followers})["data"].each do |f|
			id = f["user_id"]
			followers_users << get_user(id)["login"]
			sleep 1
		end
		followers_users
	end
	def notify(username,offline=false)
		status = !offline ? "online" : "offline"
		%x[notify-send "#{username} is #{status}"] 
	end
end
