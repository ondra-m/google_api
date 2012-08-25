require "spec_helper"

describe "GoogleApi::Shorten" do
  it "Get." do
    get = GoogleApi::Shorten.get('http://goo.gl/dOpuw')

    get.data['id'].should eql('http://goo.gl/dOpuw')
    get.data['longUrl'].should eql('https://github.com/ondra-m/google_api')
  end

  it "Insert short_url is nil if long_url isn't right url." do
    insert = GoogleApi::Shorten.insert('google_api')

    insert.short_url.should eql(nil)
  end

  it "List shour raise error." do
    lambda { GoogleApi::Shorten.list }.should raise_error(GoogleApi::SessionError)
  end
end
