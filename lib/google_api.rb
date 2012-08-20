require "google/api_client"

require "google_api/core_ext/hash"
require "google_api/configuration"
require "google_api/version"

module GoogleApi

  autoload :Cache, 'google_api/cache'

  autoload :Ga, 'google_api/ga'

  class SessionError  < StandardError; end
  class GaError       < StandardError; end
  class DateError     < StandardError; end
  class TypeError     < StandardError; end
  class CanBeNilError < StandardError; end

  CONFIGURATION = {
    client_id: nil,
    client_secret: nil,
    client_developer_email: nil,
    client_cert_file: nil,
    key_secret: 'notasecret',
    redirect_uri: nil,

    ga: Configuration.new(Ga::CONFIGURATION)
  }

  def self.config
    @config ||= Configuration.new(CONFIGURATION)
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

end
