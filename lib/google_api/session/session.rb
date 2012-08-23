require "google_api/core_ext/string"

module GoogleApi
  class Session

    attr_reader :scope

    def initialize(config_name, scope, name_api, version_api)
      @config_name = config_name
      @scope       = scope
      @name_api    = name_api
      @version_api = version_api

      @client = nil
      @api    = nil
    end

    # Login using cert file (Service account)
    #
    #   Required: client_cert_file, client_developer_email, key_secret
    #
    #   Success: return true
    #   Failure: return false
    #
    def login_by_cert
      @client = Google::APIClient.new

      key      = Google::APIClient::PKCS12.load_key(c('client_cert_file'), c('key_secret'))
      asserter = Google::APIClient::JWTAsserter.new(c('client_developer_email'), @scope, key)

      begin
        @client.authorization = asserter.authorize()
        @api = @client.discovered_api(@name_api, @version_api)
      rescue
        return false
      end

      return true
    end

    # In loop call login_by_cert
    #
    # return true after successful login
    # loop can be stopped with ctr+c - return false
    #
    def login_by_cert!
      trap("INT"){ return false }

      i = 0
      until login_by_cert
        progress_log(i+=1)
        sleep(1)
      end

      return true
    end

    # Classic oauth 2 login
    # 
    #   login() -> return autorization url
    #   login(code) -> try login, return true false
    #
    def login(code = nil)
      @client = Google::APIClient.new
      @client.authorization.client_id     = c('client_id')
      @client.authorization.client_secret = c('client_secret')
      @client.authorization.scope         = @scope
      @client.authorization.redirect_uri  = c('redirect_uri')

      @api = @client.discovered_api(@name_api, @version_api)

      unless code
        return @client.authorization.authorization_uri.to_s
      end

      begin
        @client.authorization.code = code
        @client.authorization.fetch_access_token!
      rescue
        return false
      end

      return true
    end

    # Automaticaly open autorization url a waiting for callback.
    # Launchy gem is required
    #
    # Parameters:
    #   server:: server will be on this addres, its alson address for oatuh 2 callback
    #   port:: listening port for server
    #   port=0:: server will be on first free port
    # 
    # Steps:
    # 1) create server
    # 2) launch browser and redirect to google api
    # 3) confirm and google api redirect to localhost
    # 4) server get code and start session
    # 5) close server - you are login
    #
    def login_by_line(server = 'http://localhost/oauth2callback', port = 0)
      begin
        require "launchy" # open browser
      rescue
        raise GoogleApi::RequireError, "You don't have launchy gem. Firt install it: gem install launchy."
      end
      
      require "socket"  # make tcp server 
      require "uri"     # parse uri

      uri = URI(server)

      # Start webserver.
      webserver = TCPServer.new(uri.host, port)

      # By default port is 0. It means that TCPServer will get first free port.
      # Port is required for redirect_uri.
      uri.port = webserver.addr[1]

      # Add redirect_uri for google oauth 2 callback.
      _config.send(@config_name).redirect_uri = uri.to_s

      # Open browser.
      Launchy.open(login)

      # Wait for new session.
      session = webserver.accept

      # Parse header for query.
      request = session.gets.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
      request = Hash[URI.decode_www_form(URI(request).query)]

      # Failure login
      to_return = false
      message   = "You have not been logged. Please try again."

      if login(request['code'])
        message = "You have been successfully logged. Now you can close the browser."

        to_return = true
      end

      session.write(message)

      # Close session and webserver.
      session.close

      return to_return
    end
    
    # Check session
    def check_session
      if @api.nil? || @client.nil?
        return false
      end

      return true
    end

    # Check session with error
    def check_session!
      if @api.nil? || @client.nil?
        raise GoogleApi::SessionError, "You are not log in."
      end   
    end

    def client
      check_session!

      if @client.authorization.refresh_token && @client.authorization.expired?
        @client.authorization.fetch_access_token!
      end

      @client
    end

    def api
      check_session!

      @api
    end

    private

      def progress_log(i)
        print("\r[#{Time.now.strftime("%H:%M:%S")}] ##{i} ... \r".bold)
      end

      def _config
        GoogleApi.config
      end

      def c(key)
        if _config.send(@config_name).send(key)
          _config.send(@config_name).send(key)
        else
          _config.send(key)
        end
      end

  end
end
