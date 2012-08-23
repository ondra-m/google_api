module GoogleApi
  module Ga

    CONFIGURATION = {
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

    # Data
    autoload :Data,       'google_api/ga/data'
    autoload :DataDsl,    'google_api/ga/data/data_dsl'
    autoload :FiltersDsl, 'google_api/ga/data/filters_dsl'
    autoload :SegmentDsl, 'google_api/ga/data/segment_dsl'

    @@id = 0

    def self.id(id=nil)
      if id.nil?
        return @@id
      end
      
      @@id = id.to_i
    end

    def self.cache
      GoogleApi.config.ga.cache
    end

  end
end
