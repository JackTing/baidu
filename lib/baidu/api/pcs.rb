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

      # 下载单个文件。
      # Download接口支持HTTP协议标准range定义，通过指定range的取值可以实现断点下载功能。 例如：
      # 如果在request消息中指定“Range:bytes=099”，那么响应消息中会返回该文件的前100个字节的内容；继续指定“Range: bytes=100-199”，那么响应消息中会返回该文件的第二个100字节内容。

      # 注意: 此API不直接下载文件，而是直接返回下载链接
      def download_single_file(file_path)
        default = {method: "download", path: file_path}
        "https://d.pcs.baidu.com/rest/2.0/pcs/file?#{query_params(default)}"
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