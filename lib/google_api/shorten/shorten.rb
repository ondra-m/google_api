module GoogleApi
  module Shorten

    CONFIGURATION = {}

    # Session
    autoload :Session, 'google_api/shorten/session'

    # Url
    autoload :Url, 'google_api/shorten/url/url'
    autoload :Insert, 'google_api/shorten/url/insert'
    autoload :List, 'google_api/shorten/url/list'
    autoload :Get, 'google_api/shorten/url/get'

    def self.insert(url)
      Insert.new(url)
    end

    def self.list
      List.new
    end

    def self.get(url, projection = 'FULL')
      Get.new(url, projection)
    end

  end
end
