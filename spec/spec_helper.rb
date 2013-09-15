require "rspec"
require "baidu"

$client = Baidu.configure do |config|
  config.api_key    = ""
  config.api_secret = ""
end