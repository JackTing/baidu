require 'oauth2'
require "json"

module Baidu
  class Client
    attr_accessor :api_key, :api_secret, :config
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
      @oauth_client ||= OAuth2::Client.new(self.api_key,self.api_secret,
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
      redirect_to $kanbox.authorize_url(redirect_uri: callback_session_url)
    end

    def callback
      auth_code = params[:code]
      $kanbox.token!(auth_code)
    end
  end
=end
    def authorize_url(opts = {})
      opts[:redirect_uri] ||= DEFAULT_REDIRECT_URI
      self.oauth_client.auth_code.authorize_url(redirect_uri: opts[:redirect_uri])
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
      self.access_token = self.oauth_client.auth_code.get_token(authorization_code, redirect_uri: opts[:redirect_uri])
    end

=begin rdoc
OAuth refresh_token method

Refresh tokens when token was expired

== Params:

* refresh_token - refresh_token in last got #access_token
=end
    def refresh_token!(refresh_token)
      old_token = OAuth2::AccessToken.new(self.oauth_client,'', refresh_token: refresh_token)
      self.access_token = old_token.refresh!
    end

=begin rdoc
Revert #access_token info with String access_token

You can store #access_token.token in you database or local file, when you restart you app, you can revert #access_token instance by that token

== Params:

* access_token - token in last got #access_token.token
=end
    def revert_token!(access_token)
      self.access_token = OAuth2::AccessToken.new(self.oauth_client,access_token)
    end

    # Baidu API list:
    # http://developer.baidu.com/wiki/index.php?title=docs/oauth/rest/file_data_apis_list

    # TODO: refactor for any api
    def profile
      # TODO: Bad taste
      profile_url = "#{api_url('/passport/users/getLoggedInUser')}"
      response = self.access_token.get(profile_url).body
      json     = JSON.parse(response)
      return nil if json.has_key?("error_code")
      return BaiduUser.new(uname: json['uname'], uid: json['uid'], portrait: json['portrait'])
    end

    private
     def api_url(path)
      "https://openapi.baidu.com/rest/2.0#{path}?access_token=#{self.access_token.token}"
     end

  end
end


