module GoogleApi
  class SessionMethods

    def self._session
      self.class_variable_get(:@@session)
    end
      
    def self.login_by_cert
      _session.login_by_cert
    end

    def self.login_by_cert!
      _session.login_by_cert!
    end

    def self.login(code = nil)
      _session.login(code)
    end

    def self.login_by_line(server = 'http://localhost/oauth2callback', port = 0)
      _session.login_by_line(server, port)
    end

    def self.check_session
      _session.check_session
    end

    def self.check_session!
      _session.check_session!
    end

    def self.api
      _session.api
    end

    def self.client
      _session.client
    end

  end
end
