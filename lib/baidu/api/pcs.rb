# PENDING
# http://developer.baidu.com/wiki/index.php?title=docs/pcs/rest/file_data_apis_list
module Baidu
  module Pcs

    # 获取当前用户空间配额信息。
    # https://pcs.baidu.com/rest/2.0/pcs/quota
    def pcs_quota
      quota_url = "#{pcs_base_url('quota')}"
      get_response_json(quota_url)
    end

    private
      def pcs_base_url(path)
        "https://pcs.baidu.com/rest/2.0/pcs/#{path}?access_token=#{access_token.token}"
      end

  end
end