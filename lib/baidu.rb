require "active_support/core_ext/object/to_query"
require 'active_support/concern'

%w(api/pcs api/user api/tool api/translation version client).each do |fname|
  require File.expand_path("../baidu/#{fname}", __FILE__)
end

module Baidu
  # The URI urn:ietf:wg:oauth:2.0:oob is a special URI used to identify out-of-browser applications, i.e. non-web applications.
  # DEFAULT_REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"

  # redirect_uri：必须参数，授权后要回调的URI，即接收Authorization Code的URI。如果用户在授权过程中取消授权，会回调该URI，并在URI末尾附上error=access_denied参数。对于无Web Server的应用，其值可以是“oob”，此时用户同意授权后，授权服务会将Authorization Code直接显示在响应页面的页面中及页面title中。非“oob”值的redirect_uri所在域名必须与开发者注册应用时所提供的网站根域名列表或应用的站点地址（如果根域名列表没填写）的域名相匹配。
  # http://developer.baidu.com/wiki/index.php?title=使用Authorization Code获取Access Token
  DEFAULT_REDIRECT_URI = "oob"

  class << self
    def configure(&block)
      Client.new(&block)
    end
  end
end
