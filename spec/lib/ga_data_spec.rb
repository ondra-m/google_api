require "spec_helper"

describe "GoogleApi::Ga::Data" do
  before(:each) do
    @data = GoogleApi::Ga::Data
  end



  # Default values
  # -------------------------------------------------------------------------------------------------
  it "default values" do
    @data.ids.should eql(nil)
    @data.cache.should eql(nil)
    @data.filters.should eql(nil)
    @data.segment.should eql(nil)
    @data.start_index.should eql(nil)
    @data.max_results.should eql(nil)

    @data.metrics.should eql([])
    @data.dimensions.should eql([])
    @data.sort.should eql([])

    @data.start_date.should eql(Date.today)
    @data.end_date.should eql(Date.today)
  end



  # Check date
  # -------------------------------------------------------------------------------------------------
  it "date" do
    @data.to_date("2012-08-20").should be_a_kind_of(Date)
    @data.to_date(DateTime.now).should be_a_kind_of(Date)
    lambda { @data.to_date("2012/08/20") }.should raise_error(GoogleApi::DateError)
  end



  # Check build_param
  # -------------------------------------------------------------------------------------------------
  it "build param" do
    lambda { @data.build_param("attr") }.should raise_error(GoogleApi::TypeError)

    @data.build_param([:key_1, "ga:key_2", [:key_3, [:key_4]], "ga:key_5", "ga:key_6"]).join(',').should eql("ga:key_1,ga:key_2,ga:key_3,ga:key_4,ga:key_5,ga:key_6")
  end



  # Type error
  # -------------------------------------------------------------------------------------------------
  it "type error" do
    lambda { @data.type?(1, String ) }.should raise_error(GoogleApi::TypeError)
    lambda { @data.type?(1, Integer ) }.should_not raise_error(GoogleApi::TypeError)
    lambda { @data.type?("google_api", String ) }.should_not raise_error(GoogleApi::TypeError)
  end



  # Save parameters
  # -------------------------------------------------------------------------------------------------
  it "save parameters" do
    @data = @data.ids(1)
                 .cache(1)
                 .start_date(Date.today)
                 .end_date(Date.today)
                 .metrics(:visits)
                 .dimensions(:day, :month, "ga:year")
                 .sort("ga:year", :month, :day)
                 .filters("country==Czech Republic")
                 .segment("gaid::-1")
                 .start_index(1)
                 .max_results(1)

    @data.ids.should eql(1)
    @data.cache.should eql(1)
    @data.start_date.should eql(Date.today)
    @data.end_date.should eql(Date.today)
    @data.metrics.should eql(["ga:visits"])
    @data.dimensions.should eql(["ga:day", "ga:month", "ga:year"])
    @data.sort.should eql(["ga:year", "ga:month", "ga:day"])
    @data.filters.should eql("country==Czech Republic")
    @data.segment.should eql("gaid::-1")
    @data.start_index.should eql(1)
    @data.max_results.should eql(1)
  end



  # Save parameters
  # -------------------------------------------------------------------------------------------------
  it "save parameters" do
    @data = @data.id(1)
                 .from(Date.today)
                 .to(Date.today)
                 .select(:visits)
                 .with(:day, :month, "ga:year")
                 .where("country==Czech Republic")
                 .offset(1)
                 .limit(1)

    @data.id.should eql(1)
    @data.from.should eql(Date.today)
    @data.to.should eql(Date.today)
    @data.select.should eql(["ga:visits"])
    @data.with.should eql(["ga:day", "ga:month", "ga:year"])
    @data.where.should eql("country==Czech Republic")
    @data.offset.should eql(1)
    @data.limit.should eql(1)
  end



  # Date add
  # -------------------------------------------------------------------------------------------------
  it "date add and sub" do
    @data = @data.start_date(+30).end_date(+30)

    @data.start_date.should eql(Date.today + 30)
    @data.end_date.should eql(Date.today + 30)
  end



  # Date sub
  # -------------------------------------------------------------------------------------------------
  it "date add and sub" do
    @data = @data.start_date(Date.today).end_date(Date.today)
    @data = @data.start_date(-30).end_date(-30)

    @data.start_date.should eql(Date.today - 30)
    @data.end_date.should eql(Date.today - 30)
  end



  # Metrics, dimensions and sort add and sub
  # -------------------------------------------------------------------------------------------------
  it "metrics, dimensions and sort add and sub" do
    @data = @data.metrics(:visits)
                 .dimensions(:browser)
                 .sort(:javascript)

    @data.metrics.should eql(["ga:visits"])
    @data.dimensions.should eql(["ga:browser"])
    @data.sort.should eql(["ga:javascript"])

    @data.metrics_add(:newVisits)
         .dimensions_add(:javaVersion)
         .sort_add(:resolution)

    @data.metrics.should eql(["ga:visits", "ga:newVisits"])
    @data.dimensions.should eql(["ga:browser", "ga:javaVersion"])
    @data.sort.should eql(["ga:javascript", "ga:resolution"])

    @data.metrics_sub(:newVisits)
         .dimensions_sub(:javaVersion)
         .sort_sub(:resolution)

    @data.metrics.should eql(["ga:visits"])
    @data.dimensions.should eql(["ga:browser"])
    @data.sort.should eql(["ga:javascript"])
  end



  # Filters
  # -------------------------------------------------------------------------------------------------
  it "filters" do
    @data = @data.filters{(country == "Czech Republic") & (browser != "Internet Explorer") | (visitors > 1000) | (resolution < 1000) &
                          (day >= 1) & (month <= 1) & (year =~ 1) | (operatingSystem !~ "Linux") | (javaVersion % 1) & (newVisits ** 1)}

    @data.filters.should eql("ga:country==Czech Republic;ga:browser!=Internet Explorer,ga:visitors>1000,ga:resolution<1000;ga:day>=1;ga:month<=1;ga:year=~1,ga:operatingSystem!~Linux,ga:javaVersion=@1;ga:newVisits!@1")
  end



  # Segment
  # -------------------------------------------------------------------------------------------------
  it "segment" do
    @data = @data.segment{(country == "Czech Republic") & (browser != "Internet Explorer") | (visitors > 1000) | (resolution < 1000) &
                          (day >= 1) & (month <= 1) & (year =~ 1) | (operatingSystem !~ "Linux") | (javaVersion % 1) & (newVisits ** 1)}

    @data.segment.should eql("dynamic::ga:country==Czech Republic;ga:browser!=Internet Explorer,ga:visitors>1000,ga:resolution<1000;ga:day>=1;ga:month<=1;ga:year=~1,ga:operatingSystem!~Linux,ga:javaVersion=@1;ga:newVisits!@1")
  end
end
