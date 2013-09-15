module Baidu
  module User
    extend ActiveSupport::Concern

    included do

      # 用户授权类API列表

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

      private
        def user_base_url(path, params={})
          "https://openapi.baidu.com/rest/2.0/passport/users/#{path}?#{query_params(params)}"
        end
    end
  end
end