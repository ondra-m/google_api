require "spec_helper"

describe "GoogleApi::Cache" do
  before(:each) do
    @cache = GoogleApi::Cache.new

    @cache.write("key_1", "key_1_value", 0)
    @cache.write("key_2", "key_2_value", 60)
    @cache.write("key_3", "key_3_value", 1000)
  end

  it "data read" do
    @cache.read("key_1").should eql("key_1_value")
    @cache.read("key_2").should eql("key_2_value")
    @cache.read("key_3").should eql("key_3_value")

    @cache.read("key_4").should eql(nil)
    @cache.read("key_5").should eql(nil)
  end

  it "data exists" do
    @cache.exists?("key_1").should eql(true)
    @cache.exists?("key_2").should eql(true)
    @cache.exists?("key_3").should eql(true)

    @cache.exists?("key_4").should eql(false)
    @cache.exists?("key_5").should eql(false)
  end

  it "data delete" do
    @cache.exists?("key_1").should eql(true)
    @cache.delete("key_1")
    @cache.exists?("key_1").should eql(false)

    @cache.exists?("key_2").should eql(true)
    @cache.delete("key_2")
    @cache.exists?("key_2").should eql(false)

    @cache.exists?("key_3").should eql(true)
    @cache.delete("key_3")
    @cache.exists?("key_3").should eql(false)

    @cache.exists?("key_4").should eql(false)
    @cache.delete("key_4").should eql(nil)
    @cache.exists?("key_4").should eql(false)
    
    @cache.exists?("key_5").should eql(false)
    @cache.delete("key_5").should eql(nil)
    @cache.exists?("key_5").should eql(false)
  end

  it "delete and write again" do
    @cache.exists?("key_1").should eql(true)
    @cache.delete("key_1")
    @cache.exists?("key_1").should eql(false)

    @cache.write("key_1", "key_1_value", 0)

    @cache.read("key_1").should eql("key_1_value")

    @cache.exists?("key_1").should eql(true)
  end

  it "data overwrite" do
    @cache.write("key_1", "key_1_value2")

    @cache.read("key_1").should eql("key_1_value2")
  end

  it "expire data" do
    @cache.write("key_1", "key_1_value", 0.0000001)

    sleep(0.0000001)

    @cache.exists?("key_1").should eql(false)
  end

  it "negative expires number" do
    @cache.write("key_1", "key_1_value", -1000)

    @cache.exists?("key_1").should eql(false)
  end
end
