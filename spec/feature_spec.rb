require "spec_helper"

# if you want to run test, please instead 'backup_baidu' with you application name
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

      @application_name = "backup_baidu"
      @app_dir = "/apps/#{@application_name}"
      @new_dir_path = "#{@app_dir}/gem_test_#{Time.now.to_i}"
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
        result_json  = $client.upload_single_file("#{@app_dir}/avater.jpg", @source_path)
        result_json.keys.should =~ ["path", "size", "ctime", "mtime", "md5", "fs_id", "request_id"]
      end

      it "should download a image named avater.jpg" do
        download_url = $client.download_single_file("#{@app_dir}/avater.jpg")
        response     = $client.access_token.get(download_url)

        response.status.should == 200
        response.headers["content-type"].should == "image/jpeg"
      end

      it "should create a directory" do
        response = $client.create_directory(@new_dir_path)
        response.keys.should =~ ["request_id", "ctime", "fs_id", "mtime", "path"]
      end

      it "should delete a dir" do
        response = $client.delete_single_file(@new_dir_path)
        response.keys.should =~ ["request_id"]
      end

      it "should get a image named avater.jpg meta" do
        response = $client.get_single_meta("#{@app_dir}/avater.jpg")
        response.keys.should               =~ ["list", "request_id"]
        response["list"].first.keys.should =~ ["block_list", "ctime", "filenum", "fs_id",
                                               "ifhassubdir", "isdir", "mtime", "path", "size"]
        response["list"].first["path"].should == "#{@app_dir}/avater.jpg"
        response["list"].first["isdir"].should     == 0
      end

      it "should get a dir meta" do
        response = $client.get_single_meta(@app_dir)
        response.keys.should =~ ["list", "request_id"]
        response["list"].first["path"].should  == @app_dir
        response["list"].first["isdir"].should == 1
      end

      it "should get a thumbnail image" do
        thumbnail_url = $client.get_image_thumbnail("#{@app_dir}/avater.jpg", 50, 50)
        response      = $client.access_token.get(thumbnail_url)
        response.status.should == 200
        response.headers["content-type"].should == "image/jpeg"
      end

      it "should delete a file" do
        response = $client.delete_single_file("#{@app_dir}/avater.jpg")
        response.keys.should =~ ["request_id"]
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
