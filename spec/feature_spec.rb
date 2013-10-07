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

      # the name 'backup_api' is defined when you opened you 'PCS API' to 'open' state
      # so please instead of your's
      @application_name = "backup_api"
      @app_dir = "/apps/#{@application_name}"
      @new_dir_path = "#{@app_dir}/gem_test_#{Time.now.to_i}"
    end

    describe "#Token" do

      it "should refresh token" do
        puts $client.access_token.token
        puts refresh_token = $client.access_token.refresh_token
        puts $client.refresh_token!("#{refresh_token}ss")
        puts $client.access_token.token

      end
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

      it "should get friends" do
        result_json = $client.get_friends
        result_json.first.keys.should =~ ["uid", "uname", "portrait"]
      end

      it "should return some friends relations" do
        uids1 = "2718323483,402818250,2819457800"
        uids2 = "1527552252,3289658540,1694714450"
        result_json = $client.areFriends(uids1, uids2)
        result_json.size.should == 3
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
        response["list"].first["path"].should  == "#{@app_dir}/avater.jpg"
        response["list"].first["isdir"].should == 0
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

    describe "#Tool" do
      it "query with your ip " do
        ip = "163.179.238.216"
        result_json = $client.query_with_ip(ip)
        result_json[ip]["province"].should == "广东"
        result_json[ip]["city"].should     == "惠州"
      end
    end

    describe "#Translate" do
      it "should translate 'Today' to '今天'" do
        result_json = $client.translate("en", "zh", "Today")
        result_json["trans_result"][0]["src"].should == "Today"
        result_json["trans_result"][0]["dst"].should == "今天"
      end
    end

  end
end