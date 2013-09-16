module Baidu
  module Tool
    extend ActiveSupport::Concern

    included do

      # 查询IP地址所在地区
      # 根据ip计算出用户对应的省份与城市。如果应用还没有开通平台授权权限，可以暂时使用用户token来调用此API。
      # https://openapi.baidu.com/rest/2.0/iplib/query
      # ip: 系统输入参数为编码为UTF-8格式编码。需要查询的ip地址，多个ip地址请用英文逗号隔开。
      def query_with_ip(ip)
        default = {ip: ip}
        query_url = "https://openapi.baidu.com/rest/2.0/iplib/query?#{query_params(default)}"
        get_response_json(query_url)
      end

    end
  end
end