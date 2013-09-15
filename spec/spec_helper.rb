require "rspec"
require "baidu"

$client = Baidu.configure do |config|
  config.api_key    = "ecrX8BsAoe21WGLX5f62QQyG"
  config.api_secret = "FzNghIyiPuQhHPoZfNK7Od8YlzgMDmv4"
end