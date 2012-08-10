module GoogleApi
  class Configuration

    DEFAULT = {
      email: "o"
      # client_id: nil,
      # client_secret: nil,
      # client_cert_file: nil,
      # access_token: nil,

      # ga: GoogleApi::Ga::Configuration.new
    }

    DEFAULT.each do |key, value|
      eval <<-METHOD
        def #{key}=(value)
          @#{key} = value
        end

        def #{key}
          if block_given?
            yield @#{key}
          else
            @#{key}
          end
        end
      METHOD
    end

    def initialize(config = {}, &block)
      configure(DEFAULT.merge(config), &block)
    end

    def configure(config = {})
      config.each do |key, value|
        self.send("#{key}=", value)
      end

      if block_given?
        yield self 
      end

      self
    end
    
  end
end