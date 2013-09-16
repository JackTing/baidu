require "spec_helper"

describe "Bidu" do
  describe "Feature" do
    before :all do
      url = $client.authorize_url
      puts "="*20
      puts "Please open and login: #{url}"
      print "Authorize Code:"
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
        result_json  = $client.upload_single_file("/apps/backup_baidu/avater.jpg", @source_path)
        result_json.keys.should =~ ["path", "size", "ctime", "mtime", "md5", "fs_id", "request_id"]
      end

      it "should download a image named avater.jpg" do
        download_url = $client.download_single_file("/apps/backup_baidu/avater.jpg")
        response = $client.access_token.get(download_url)

        response.status.should == 200
        puts response.headers["content-type"].should == "image/jpeg"
      end

    end
  end
end