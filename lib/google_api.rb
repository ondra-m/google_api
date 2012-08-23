require "google/api_client"

require "google_api/core_ext/hash"
require "google_api/configuration"
require "google_api/version"

module GoogleApi

  autoload :Session,        'google_api/session/session'
  autoload :SessionMethods, 'google_api/session/session_methods'

  autoload :Cache, 'google_api/cache'

  autoload :Ga,      'google_api/ga/ga'           # Google analytics
  autoload :Shorten, 'google_api/shorten/shorten' # Google urlshortener

  class SessionError  < StandardError; end
  class GaError       < StandardError; end
  class ShortenError  < StandardError; end
  class DateError     < StandardError; end
  class TypeError     < StandardError; end
  class CanBeNilError < StandardError; end
  class RequireError  < StandardError; end

  # Global configuration
  CONFIGURATION = {
    ga:      Configuration.new(Ga::CONFIGURATION),
    shorten: Configuration.new(Shorten::CONFIGURATION)
  }

  def self.config
    @config ||= Configuration.new(CONFIGURATION)
  end

  def self.configure(&block)
    config.instance_eval(&block)
  end

end
