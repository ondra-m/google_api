require "google_api/configuration"
require "google_api/version"

module GoogleApi
  
  autoload :Ga, 'google_api/ga'

  CONFIGURATION = {
    email: nil,
    client_id: nil,
    client_secret: nil,
    client_cert_file: nil,
    access_token: nil,

    ga: Configuration.new(Ga::CONFIGURATION)
  }

  class << self
    def config
      @config ||= Configuration.new(CONFIGURATION)
    end

    def configure(&block)
      config.configure(&block)
    end
  end

end
