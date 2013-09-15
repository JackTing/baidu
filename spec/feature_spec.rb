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

    describe "#is_app_user" do
      it "should is app user" do
        result_json = $client.is_app_user
        result_json["result"].should == "1"
      end
    end

  end
end
