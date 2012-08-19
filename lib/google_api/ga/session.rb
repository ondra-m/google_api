require "google_api/core_ext/string"

module GoogleApi
  module Ga
    
    class Session

      SCOPE       = "https://www.googleapis.com/auth/analytics.readonly"
      NAME_API    = "analytics"
      VERSION_API = "v3"

      @@api    = nil
      @@client = nil

      # Config --------------------------------------------------------------------------------

      def self._config
        GoogleApi.config
      end

      def self.client_id
        _config.ga.client_id ? _config.ga.client_id : _config.client_id
      end

      def self.client_secret
        _config.ga.client_secret ? _config.ga.client_secret : _config.client_secret
      end

      def self.redirect_uri
        _config.ga.redirect_uri ? _config.ga.redirect_uri : _config.redirect_uri
      end

      def self.client_cert_file
        _config.ga.client_cert_file ? _config.ga.client_cert_file : _config.client_cert_file
      end

      def self.client_developer_email
        _config.ga.client_developer_email ? _config.ga.client_developer_email : _config.client_developer_email
      end

      def self.key_secret
        _config.ga.key_secret ? _config.ga.key_secret : _config.key_secret
      end

      # ---------------------------------------------------------------------------------------

      def self.login_by_cert
        @@client = Google::APIClient.new

        key      = Google::APIClient::PKCS12.load_key(client_cert_file, key_secret)
        asserter = Google::APIClient::JWTAsserter.new(client_developer_email, SCOPE, key)

        begin
          @@client.authorization = asserter.authorize()
          @@api = @@client.discovered_api(NAME_API, VERSION_API)
        rescue
          return false
        end

        return true
      end

      def self.login_by_cert!
        i = 0
        while !login_by_cert
          print "\r[#{Time.now.strftime("%H:%M:%S")}] ##{i += 1} ... \r".bold
          sleep(1)
        end

        return true
      end

      def self.login(code = nil)
        @@client = Google::APIClient.new
        @@client.authorization.client_id     = client_id
        @@client.authorization.client_secret = client_secret
        @@client.authorization.scope         = SCOPE
        @@client.authorization.redirect_uri  = redirect_uri

        @@api = @@client.discovered_api(NAME_API, VERSION_API)

        if code
          @@client.authorization.code = code

          begin
            @@client.authorization.fetch_access_token!
          rescue
            return false
          end

          return true
        else
          @@client.authorization.authorization_uri.to_s
        end
      end

      def self.login_by_line(server = 'http://localhost/oauth2callback', port = 0)
        require "launchy" # open browser
        require "socket"  # make tcp server 
        require "uri"     # parse uri

        uri = URI(server)

        # Start webserver.
        webserver = TCPServer.new(uri.host, port)

        # By default port is 0. It means that TCPServer will get first free port.
        # Port is required for redirect_uri.
        uri.port = webserver.addr[1]

        # Add redirect_uri for google oauth 2 callback.
        GoogleApi.config.ga.redirect_uri = uri.to_s

        # Open browser.
        Launchy.open(login)

        # Wait for new session.
        session = webserver.accept

        # Parse header for query.
        request = session.gets.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
        request = Hash[URI.decode_www_form(URI(request).query)]

        code = request['code']

        # Close session and webserver.
        session.close

        if login(code)
          session.write("You have been successfully logged. Now you can close the browser.")

          return true
        end

        session.write("You have not been logged. Please try again.")

        return false
      end

      def self.check_session!
        if @@api.nil? || @@client.nil?
          raise GoogleApi::SessionError, "You are not log in."
        end
      end

      def self.api
        check_session!

        @@api
      end

      def self.client
        check_session!

        if @@client.authorization.refresh_token && @@client.authorization.expired?
          @@client.authorization.fetch_access_token!
        end

        @@client
      end

    end

  end
end
