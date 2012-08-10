require "spec_helper"

describe "GoogleApi config" do

  before(:each) do
    @email = "ondra1166@gmail.com"

    GoogleApi.configure do |config|
      config.email = @email

      config.ga do |ga|
        ga.client_cert_file = "/home/ondra/projekty/a8edafa07571f8bb093534c1c7d69a7f038ba456-privatekey.p12"
        ga.client_developer_email = "721218934542@developer.gserviceaccount.com"
      end
    end
  end

  it "should have right config" do
    GoogleApi.config.email.should equal(@email)
  end

  it "login" do
    GoogleApi::Ga::Session.login_by_cert
  end

end
