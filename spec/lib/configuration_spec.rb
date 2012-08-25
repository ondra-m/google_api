require "spec_helper"

describe "GoogleApi::Configuration" do
  it "Dsl" do
    GoogleApi.configure do
      client_id "1"
      client_secret "2"
      client_developer_email "3"

      ga do
        client_id "4"
        client_secret "5"
        client_developer_email "6"
      end

      shorten do
        client_id "7"
        client_secret "8"
        client_developer_email "9"
      end
    end

    GoogleApi.config.client_id.should eq("1")
    GoogleApi.config.client_secret.should eq("2")
    GoogleApi.config.client_developer_email.should eq("3")

    GoogleApi.config.ga.client_id.should eq("4")
    GoogleApi.config.ga.client_secret.should eq("5")
    GoogleApi.config.ga.client_developer_email.should eq("6")

    GoogleApi.config.shorten.client_id.should eq("7")
    GoogleApi.config.shorten.client_secret.should eq("8")
    GoogleApi.config.shorten.client_developer_email.should eq("9")
  end

  it "Classic" do
    GoogleApi.configure do |config|
      config.client_id "1"
      config.client_secret "2"
      config.client_developer_email "3"

      config.ga do |ga_config|
        ga_config.client_id "4"
        ga_config.client_secret "5"
        ga_config.client_developer_email "6"
      end

      config.shorten do |shorten_config|
        shorten_config.client_id "7"
        shorten_config.client_secret "8"
        shorten_config.client_developer_email "9"
      end
    end

    GoogleApi.config.client_id.should eq("1")
    GoogleApi.config.client_secret.should eq("2")
    GoogleApi.config.client_developer_email.should eq("3")

    GoogleApi.config.ga.client_id.should eq("4")
    GoogleApi.config.ga.client_secret.should eq("5")
    GoogleApi.config.ga.client_developer_email.should eq("6")

    GoogleApi.config.shorten.client_id.should eq("7")
    GoogleApi.config.shorten.client_secret.should eq("8")
    GoogleApi.config.shorten.client_developer_email.should eq("9")
  end

  it "Minimal" do
    GoogleApi.config.client_id = "1"
    GoogleApi.config.client_secret = "2"
    GoogleApi.config.client_developer_email = "3"

    GoogleApi.config.ga.client_id = "4"
    GoogleApi.config.ga.client_secret = "5"
    GoogleApi.config.ga.client_developer_email = "6"

    GoogleApi.config.shorten.client_id = "7"
    GoogleApi.config.shorten.client_secret = "8"
    GoogleApi.config.shorten.client_developer_email = "9"

    GoogleApi.config.client_id.should eq("1")
    GoogleApi.config.client_secret.should eq("2")
    GoogleApi.config.client_developer_email.should eq("3")

    GoogleApi.config.ga.client_id.should eq("4")
    GoogleApi.config.ga.client_secret.should eq("5")
    GoogleApi.config.ga.client_developer_email.should eq("6")

    GoogleApi.config.shorten.client_id.should eq("7")
    GoogleApi.config.shorten.client_secret.should eq("8")
    GoogleApi.config.shorten.client_developer_email.should eq("9")
  end
end
