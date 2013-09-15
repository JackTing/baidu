# http://developer.baidu.com/wiki/index.php?title=docs/pcs/rest/file_data_apis_list
module Baidu
  module Pcs
    extend ActiveSupport::Concern

    included do

      # 获取当前用户空间配额信息。
      # https://pcs.baidu.com/rest/2.0/pcs/quota
      # scope: netdisk
      def pcs_quota
        quota_url = "#{pcs_base_url('quota', method: 'info')}"
        get_response_json(quota_url)
      end

      # 上传单个文件。
      # 百度PCS服务目前支持最大2G的单个文件上传。
      # 如需支持超大文件（>2G）的断点续传，请参考下面的“分片文件上传”方法。
      def upload_single_file(yun_path, source_file_path="", opts={})
        require 'rest-client'
        source_file = File.open(source_file_path)
        response    = RestClient.post(upload_file_url(path: yun_path), file: source_file)
        JSON.parse(response)
      end

      private
        def pcs_base_url(path, params={})
          "https://pcs.baidu.com/rest/2.0/pcs/#{path}?#{query_params(params)}"
        end

        # overwrite：表示覆盖同名文件；
        # newcopy：表示生成文件副本并进行重命名，命名规则为“文件名_日期.后缀”。
        def upload_file_url(params={})
          default = {method: "upload", ondup: "newcopy"}
          params  = params.merge(default)
          "https://c.pcs.baidu.com/rest/2.0/pcs/file?#{query_params(params)}"
        end
    end
  end
end