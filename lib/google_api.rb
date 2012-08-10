require "google_api/version"

module GoogleApi
  
  class << self
    def config
      @config ||= GoogleApi::Configuration.new
    end

    def configure(attributes = {}, &block)  
      config.configure(attributes, &block)
    end
  end

end
