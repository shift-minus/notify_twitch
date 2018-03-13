
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "notify_twitch/version"

Gem::Specification.new do |spec|
  spec.name          = "notify_twitch"
  spec.version       = NotifyTwitch::VERSION
  spec.authors       = ["ShiftMinus"]
  spec.email         = ["shift.minus.media@gmail.com"]
	spec.summary       =  "Desktop notifications when Twitch streams come online"
  spec.homepage      = "https://github.com/shift-minus/notify-twitch"
  spec.license       = "MIT"
  spec.files         = ["lib/notify_twitch.rb","lib/notify_twitch/config.rb","bin/notify-twitch"]
  spec.bindir        = "bin"
  spec.executables   = ["notify-twitch"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
