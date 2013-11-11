module Baidu
  module Bcs
    extend ActiveSupport::Concern

    included do

      BCS_HOST = 'bcs.duapp.com'

      # 创建bucket
      # [public-read|public-write|public-read-write|public-control|private] default: private
      # acl: x-bs-acl
      # PUT
      def create_bucket(bucket_name, acl)

      end

      # 列举属于自己的bucket
      # GET
      def list_buckets

      end

      # 删除bucket，用户必需有删除权限，才能执行成功。
      # DELETE
      def delete_bucket(bucket_name)

      end




      private

      # 算法规则
      # 云存储服务的签名算法规则如下：

      # 1. 生成Signature的算法规则：

      #  Signature=urlencode(base64_encode(hash_hmac('sha1', Content, SecretKey,true)))
      # 2. 生成Content的算法规则：

      # Content由Flag、 bucket、object以及各个参数组成。

      # 如：

      # Content= Flag + "\n"
      #           + "Method=" + "\n"
      #           + "Bucket=" + "\n"
      #           + "Object=" + "\n"
      #           + "Time=" + "\n"
      #           + "Ip=" + "\n"
      #           + "Size=" + "\n"
      # 签名使用
      # 如需使用签名访问，则每次请求都需要把相应的签名通过querystring的方式发送，例如：

      #  sign=MBO:aCLCZtoFQg8I:WQMFNZEhN2k8xxlgikuPfCJMuE8%3D
      # 身份验证基本原理
      # 云存储服务的签名算法实现身份验证的基本原理如下：

      # 1. 用户根据自己申请的AK、SK和请求内容计算出Signature，然后通过querystring的方式发送给云存储；

      # 2. 云存储服务器端自动根据Flag计算相关签名；

      # 3. 如果云存储计算的结果与请求的相同，则认证通过，否则返回403。

      # ref:http://stackoverflow.com/questions/4084979/ruby-way-to-generate-a-hmac-sha1-signature-for-oauth
        def bcs_sign
          [api_key, api_secret, BCS_HOST]
        end

    end
  end
end