module GoogleApi
  module Ga

    CONFIGURATION = {
      client_id: nil,
      client_secret: nil,
      client_developer_email: nil,
      client_cert_file: nil,
      key_secret: 'notasecret',
      redirect_uri: nil,

      cache: GoogleApi::Cache.new
    }

    # Session
    autoload :Session, 'google_api/ga/session'

    # Management
    autoload :Management,  'google_api/ga/management/management'
    autoload :Account,     'google_api/ga/management/account'
    autoload :Webproperty, 'google_api/ga/management/webproperty'
    autoload :Profile,     'google_api/ga/management/profile'
    autoload :Goal,        'google_api/ga/management/goal'
    autoload :Segment,     'google_api/ga/management/segment'

    # Helper
    autoload :Helper, 'google_api/ga/helper'

    # Data
    autoload :Data,    'google_api/ga/data'
    autoload :DataDsl, 'google_api/ga/data/data_dsl'
    autoload :Filter,  'google_api/ga/data/filter'
    autoload :Segment, 'google_api/ga/data/segment'

    extend GoogleApi::Ga::Helper

    @@id = 0

    def self.id(id=nil)
      if id.nil?
        return @@id
      end
      
      @@id = id
    end

    def self.cache
      GoogleApi.config.ga.cache
    end

  end
end
