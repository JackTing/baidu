# encoding: utf-8

require "rspec"
require "api4baidu"

$client = Baidu.configure do |config|
  config.api_key    = "lZUsGbfnXOkwa2tvtZVI1Sn7"
  config.api_secret = "qjhCau3p8EIPmZKAHyEArKn19H74FtEj"
end