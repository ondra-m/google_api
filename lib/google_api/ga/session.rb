module GoogleApi
  module Ga
    class Session < GoogleApi::SessionMethods

      SCOPE       = "https://www.googleapis.com/auth/analytics.readonly"
      NAME_API    = "analytics"
      VERSION_API = "v3"

      CONFIG_NAME = "ga"

      @@session = GoogleApi::Session.new(CONFIG_NAME, SCOPE, NAME_API, VERSION_API)

    end
  end
end
