require "spec_helper"

describe "GoogleApi::Ga" do
  it "set default profile id" do
    GoogleApi::Ga.id.should eql(0)
    
    GoogleApi::Ga.id(1)

    GoogleApi::Ga.id.should eql(1)
  end
end
