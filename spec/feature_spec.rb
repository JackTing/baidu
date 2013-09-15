require "spec_helper"

describe "Bidu" do
  describe "Feature" do
    before :all do
      url = $client.authorize_url
      puts "="*20
      puts "Please open and login: #{url}"
      print "Code:"
      auth_code = $stdin.gets.chomp.split("\n").first
      $client.token!(auth_code)
      puts "access_token = %s" % $client.access_token.token
    end

    describe "#User personal info" do
      it "should is app user" do
        result_json = $client.is_app_user
        result_json["result"].should == "1"
      end

      it "should get loggedin user infos" do
        result_json = $client.get_loggedin_user
        result_json.keys.should =~ ["uid", "uname", "portrait"]
      end

      it "should get user details infos" do
        result_json = $client.get_user_info
        result_json.keys.should =~ ["userid", "username", "birthday", "marriage", "sex", "blood", "constellation", "figure", "trade", "job", "portrait", "education"]
      end
    end

    describe "#User netdisk" do
      it "should get loggedin user netdisk info" do
        result_json = $client.pcs_quota
        result_json.keys.should =~ ["quota", "used", "request_id"]
      end

      it "should upload a image file to baidu yun" do
        @source_path = File.expand_path("../fixtures/avater.jpg", __FILE__)
        result_json = $client.upload_single_file("/apps/backup_baidu/avater.jpg", @source_path)
        result_json.keys.should =~ ["path", "size", "ctime", "mtime", "md5", "fs_id", "request_id"]
      end
    end

  end
end

# "path" : "/apps/album/1.jpg",
# 　    "size" : 372121,
# 　    "ctime" : 1234567890,
# 　    "mtime" : 1234567890,
# 　    "md5" : "cb123afcc12453543ef",
# 　    "fs_id" : 12345,
#     　"request_id":4043312669


# URL：https://pcs.baidu.com/rest/2.0/pcs/file?method=upload&path=%2Fapps%2F%E6%B5%8B%E8%AF%95%E5%BA%94%E7%94%A8%2F&access_token=3.dc0c86661a0c7dce04bbcfcef1ec09a0.2592000.1381770240.1863251187-248414

# https://pcs.baidu.com/rest/2.0/pcs/file?access_token=3.66c84d85120868c1cbe4ba41ec7b32df.2592000.1381818039.1863251187-1340991&method=upload&ondup=newcopy&path=%2Fapps%2Fimages%2Ftest.jpg

# https://c.pcs.baidu.com/rest/2.0/pcs/file?access_token=3.4a6c9c801ec5d0b89c6a041e91efdfbc.2592000.1381817602.1863251187-1340991&method=upload&ondup=newcopy&url=app%2Fimages%2Ftest.jpg

