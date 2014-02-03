# encoding: utf-8

module Baidu
  module Translation
    extend ActiveSupport::Concern

    included do

      # http://openapi.baidu.com/public/2.0/bmt/translate
      # auto   auto  自动识别
      # zh   en  中 -> 英
      # zh   jp  中 -> 日
      # en   zh  英 -> 中
      # jp   zh  日 -> 中
      # client_id=YourApiKey&q=today&from=auto&to=auto
      def translate(from="auto", to="auto", q)
        params = {from: from, to: to, q: q, client_id: api_key}.to_query
        translate_url = "http://openapi.baidu.com/public/2.0/bmt/translate?#{params}"
        get_response_json(translate_url)
      end

    end
  end
end