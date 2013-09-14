# Baidu

 Ruby gem for Baidu <http://www.baidu.com> apis.
  **Developing**

## Installation

Add this line to your application's Gemfile:

    gem 'baidu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baidu

## Usage

### Config

```ruby

$client = Baidu.configure do |config|
  config.api_key = "you client id"
  config.api_secret = "you client secert"
end

```

### GetLoggedInUser info

```ruby

$client.authorize_url

# 访问上面生成的链接，并复制授权码: "515a268fd483ff4df85d2d458d34b43a"
$client.token!("515a268fd483ff4df85d2d458d34b43a")

# 获取当前登录用户的用户uid、用户名和头像。
$client.profile

 => Result:
#<Baidu::BaiduUser:0x007fe45a5ee250
 @portrait="ba6f303830373531353231302c0a",
 @uid="1863251187",
 @uname="ruby_baidu_sdk">

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
