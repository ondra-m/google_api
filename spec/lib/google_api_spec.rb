require "spec_helper"

describe "GoogleApi::Configuration" do
  it "Setting is right." do
    GoogleApi.configure do
      client_id "1"
      client_secret "2"
      client_developer_email "3"

      ga do
        client_id "4"
        client_secret "5"
        client_developer_email "6"
      end
    end

    GoogleApi.config.client_id.should eq("1")
    GoogleApi.config.client_secret.should eq("2")
    GoogleApi.config.client_developer_email.should eq("3")

    GoogleApi.config.ga.client_id.should eq("4")
    GoogleApi.config.ga.client_secret.should eq("5")
    GoogleApi.config.ga.client_developer_email.should eq("6")

    GoogleApi.configure do |config|
      config.client_id "7"
      config.client_secret "8"
      config.client_developer_email "9"

      config.ga do |ga_config|
        ga_config.client_id "10"
        ga_config.client_secret "11"
        ga_config.client_developer_email "12"
      end
    end

    GoogleApi.config.client_id.should eq("7")
    GoogleApi.config.client_secret.should eq("8")
    GoogleApi.config.client_developer_email.should eq("9")

    GoogleApi.config.ga.client_id.should eq("10")
    GoogleApi.config.ga.client_secret.should eq("11")
    GoogleApi.config.ga.client_developer_email.should eq("12")

    GoogleApi.config.client_id = "13"
    GoogleApi.config.client_secret = "14"
    GoogleApi.config.client_developer_email = "15"

    GoogleApi.config.ga.client_id = "16"
    GoogleApi.config.ga.client_secret = "17"
    GoogleApi.config.ga.client_developer_email = "18"

    GoogleApi.config.client_id.should eq("13")
    GoogleApi.config.client_secret.should eq("14")
    GoogleApi.config.client_developer_email.should eq("15")

    GoogleApi.config.ga.client_id.should eq("16")
    GoogleApi.config.ga.client_secret.should eq("17")
    GoogleApi.config.ga.client_developer_email.should eq("18")
  end
end
