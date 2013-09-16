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
        response     = $client.access_token.get(download_url)

        response.status.should == 200
        puts response.headers["content-type"].should == "image/jpeg"
      end

      # it "should create a '/apps/gem_test' directory" do
      #   response = $client.create_directory("/apps/sss/")
      #   puts response
      # end

      it "should get a image named avater.jpg meta" do
        response = $client.get_single_meta("/apps/backup_baidu/avater.jpg")
        response.keys.should               =~ ["list", "request_id"]
        response["list"].first.keys.should =~ ["block_list", "ctime", "filenum", "fs_id",
                                               "ifhassubdir", "isdir", "mtime", "path", "size"]
        puts response["list"].first["path"].should == "/apps/backup_baidu/avater.jpg"
        response["list"].first["isdir"].should     == 0
      end

      it "should get a dir meta" do
        response = $client.get_single_meta("/apps/backup_baidu")
        response.keys.should =~ ["list", "request_id"]
        response["list"].first["path"].should  == "/apps/backup_baidu"
        response["list"].first["isdir"].should == 1
      end

      # it "should delete a fiel" do
      #   response = $client.delete_single_file("/apps/backup_baidu/avater.jpg")
      #   response.keys.should =~ ["request_id"]
      # end

      it "should delete a dir" do
        response = $client.delete_single_file("/apps/test_delete")
        puts response
      end

    end
  end
end


# "list" : [ { "fs_id" : 3528850315,
#         "path" : "/apps/yunform/music/hello",
#         "ctime" : 1331184269,
#         "mtime" : 1331184269,
#         "block_list":["59ca0efa9f5633cb0371bbc0355478d8"],
#         "size" : 13,
#         "isdir" : 1
#                  } ],
#         "request_id" : 4043312678
