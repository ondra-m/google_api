module GoogleApi
  module Shorten
    class Session < GoogleApi::SessionMethods

      SCOPE       = "https://www.googleapis.com/auth/urlshortener"
      NAME_API    = "urlshortener"
      VERSION_API = "v1"

      CONFIG_NAME = "shorten"

      @@session = GoogleApi::Session.new(CONFIG_NAME, SCOPE, NAME_API, VERSION_API)

    end
  end
end

