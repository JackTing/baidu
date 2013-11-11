# Baidu

 Ruby gem for Baidu <http://developer.baidu.com> apis.
  **Developing**

 Rubygems: <https://rubygems.org/gems/api4baidu>

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
  config.api_key    = "you client id"
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
 {"uid"    => "1863251187",
 "uname"   => "0807515210",
 "portrait"=> "ba6f303830373531353231302c0a"}

```

### For controller

```ruby

class SessionController
  def oauth
    redirect_to $baidu.authorize_url(redirect_uri: "you redirect url")
  end

  def callback
    auth_code = params[:code]
    $baidu.token!(auth_code)
  end
end

```

更多使用例子请查看 `spec`目录

## 已完成API列表

### 用户基础信息

1. 获取当前登录用户的信息: get_loggedin_user

2. 返回指定用户的用户资料: get_user_info

3. 平台授权相关的权限: get_app_permission

4. 判断用户是否为应用用户: is_app_user

5. 返回用户好友资料: get_friends

6. 获得指定用户之间好友关系: areFriends

### PCS

1. 获取当前用户空间配额信息: pcs_quota

2. 上传单个文件: upload_single_file

3. 下载单个文件: download_single_file

4. 创建目录: create_directory

5. 获取单个文件/目录的元信息: get_single_meta

6. 删除单个文件/目录: delete_single_file

7. 获取指定图片文件的缩略图: get_image_thumbnail

### 翻译

1. 翻译: translate

### 工具

1. 查询IP地址所在地区: query_with_ip


## Doing

1. BCS: http://developer.baidu.com/cloud/stor

2. 云消息: http://developer.baidu.com/cloud/mq

3. 云推送: http://developer.baidu.com/cloud/push

4. 媒体云: http://developer.baidu.com/cloud/media


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
