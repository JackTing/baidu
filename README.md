# Baidu

 Ruby gem for Baidu <http://developer.baidu.com> apis.
  **Developing**

 Rubygems: https://rubygems.org/gems/api4baidu

## Installation

Add this line to your application's Gemfile:

    gem "api4baidu"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api4baidu

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
$client.get_loggedin_user

 => Result:
 {"uid"=>"1863251187",
 "uname"=>"0807515210",
 "portrait"=>"ba6f303830373531353231302c0a"}

```

更多使用例子请查看 `spec`目录

## TODO

1. 逐步完善所有API对接

2. 重构oauth2，分离出独立的gem实现

3. 添加Terminal命令控制

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
