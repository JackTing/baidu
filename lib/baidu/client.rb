require 'oauth2'
require "json"

module Baidu
  class Client

    attr_accessor :api_key, :api_secret
    ##
    # OAuth2::AccessToken
    #
    # Store authorized infos
    attr_accessor :access_token

    def initialize(&block)
      instance_eval &block
    end

    ##
    # OAuth2::Client instance with baido OAuth
    # http://developer.baidu.com/wiki/index.php?title=docs/oauth/application
    def oauth_client
      @oauth_client ||= OAuth2::Client.new(api_key, api_secret,
                                          site: "https://openapi.baidu.com",
                                          authorize_url: "/oauth/2.0/authorize",
                                          token_url: "/oauth/2.0/token")

    end


=begin rdoc
OAuth2 +authorize_url+

redirect or open this URL for login in Baidu website

=== Params:

* +opts+ Hash
  * +redirect_uri+ String - default Baidu::DEFAULT_REDIRECT_URI,URL with logined redirect back

=== Rails example:

  class SessionController
    def oauth
      redirect_to $baidu.authorize_url(redirect_uri: callback_session_url)
    end

    def callback
      auth_code = params[:code]
      $baidu.token!(auth_code)
    end
  end
=end
    def authorize_url(opts = {})
      opts[:redirect_uri] ||= DEFAULT_REDIRECT_URI
      # scope：非必须参数，以空格分隔的权限列表，若不传递此参数，代表请求用户的默认权限。关于权限的具体信息请参考“权限列表”。
      opts[:scope] ||= "basic netdisk super_msg"
      oauth_client.auth_code.authorize_url(scope: opts[:scope], redirect_uri: opts[:redirect_uri])
    end


=begin rdoc
OAuth get_token method

This method will get #access_token (OAuth2::AccessToken) ... and save in Baidu instance

== Params:

* authorization_code - Authorization Code in callback URL
* opts
  * +redirect_uri+ String - default Baidu::DEFAULT_REDIRECT_URI,URL with logined redirect back
=end
    def token!(authorization_code,opts = {})
      opts[:redirect_uri] ||= DEFAULT_REDIRECT_URI
      self.access_token = oauth_client.auth_code.get_token(authorization_code, redirect_uri: opts[:redirect_uri])
    end

    def token
      @token ||= access_token.token
    end

=begin rdoc
OAuth refresh_token method

Refresh tokens when token was expired

== Params:

* refresh_token - refresh_token in last got #access_token
=end
    def refresh_token!(refresh_token)
      old_token = OAuth2::AccessToken.new(oauth_client,'', refresh_token: refresh_token)
      self.access_token = old_token.refresh!
    end

=begin rdoc
Revert #access_token info with String access_token

You can store #access_token.token in you database or local file, when you restart you app, you can revert #access_token instance by that token

== Params:

* access_token - token in last got #access_token.token
=end
    def revert_token!(access_token)
      self.access_token = OAuth2::AccessToken.new(oauth_client, access_token)
    end

    # Baidu API list:
    # http://developer.baidu.com/wiki/index.php?title=docs/oauth/rest/file_data_apis_list

    # 用户授权类API列表

    ## 用户信息类接口

    # 获取当前登录用户的信息
    # passport/users/getLoggedInUser
    def get_loggedin_user
      profile_url = "#{user_base_url('getLoggedInUser')}"
      get_response_json(profile_url)
    end

    # 返回指定用户的用户资料。
    # https://openapi.baidu.com/rest/2.0/passport/users/getInfo
    # uid default "", will return current user info
    # if you want to access other user info, you should have this permission
    def get_user_info(uid="")
      user_info_url = "#{user_base_url('getInfo', uid: uid)}"
      get_response_json(user_info_url)
    end

    #用户授权相关的权限   介绍
    # basic  用户基本权限，可以获取用户的基本信息 。
    # super_msg  往用户的百度首页上发送消息提醒，相关API任何应用都能使用，但要想将消息提醒在百度首页显示，需要第三方在注册应用时额外填写相关信息。
    # netdisk  获取用户在个人云存储中存放的数据。

    # 平台授权相关的权限  介绍
    # public   可以访问公共的开放API。
    # hao123   可以访问Hao123 提供的开放API接口该权限需要申请开通，请将具体的理由和用途发邮件给tuangou@baidu.com。
    def get_app_permission(uid="", ext_perms)
      app_permissions_url = "#{user_base_url('hasAppPermissions', {uid: uid, ext_perms: ext_perms})}"
      get_response_json(app_permissions_url)
    end

    # refactor
    def is_app_user(uid="")
      app_user_url = "#{user_base_url('isAppUser', uid: uid)}"
      get_response_json(app_user_url)
    end

    # 好友关系类接口。

    # 用户授权类接口

    # 超级个人中心通知提醒类接口

    # 平台授权类API列表

    # 团购类API列表

    # 工具类API列表

    # 高级API列表

    # PCS

    # 获取当前用户空间配额信息。
    # https://pcs.baidu.com/rest/2.0/pcs/quota
    # scope: netdisk
    def pcs_quota
      quota_url = "#{pcs_base_url('quota', method: 'info')}"
      get_response_json(quota_url)
    end

    def upload_single_file
      upload_single_file_url = "#{pcs_base_url('file')}"
      post_json(upload_single_file_url)
    end

    private

      def pcs_base_url(path, params={})
        "https://pcs.baidu.com/rest/2.0/pcs/#{path}?#{query_params(params)}"
      end

      def user_base_url(path, params={})
        params.merge!({access_token: token})
        "https://openapi.baidu.com/rest/2.0/passport/users/#{path}?#{query_params(params)}"
      end

      def query_params(params)
        params.merge!({access_token: token})
        params.to_param
      end

      def get_response_json(api_url)
        JSON.parse(access_token.get(api_url).body)
      end

      def post_json(api_url)
        "pending"
      end

  end
end


