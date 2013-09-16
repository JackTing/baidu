require 'oauth2'
require "json"
require 'rest-client'

module Baidu
  class Client

    include Pcs
    include User

    attr_accessor :api_key, :api_secret
    ##
    # OAuth2::AccessToken
    #
    # Store authorized infos
    attr_accessor :access_token

    def initialize(&block)
      instance_eval(&block)
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

    # 好友关系类接口。

    # 用户授权类接口

    # 超级个人中心通知提醒类接口

    # 平台授权类API列表

    # 团购类API列表

    # 工具类API列表

    # 高级API列表

    private

      def query_params(params)
        params.merge({access_token: token}).to_query
      end

      def get_response_json(api_url)
        JSON.parse(access_token.get(api_url).body)
      end
  end
end