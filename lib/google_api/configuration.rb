module GoogleApi
  class Configuration

    DEFAULT = {
      client_id: nil,
      client_secret: nil,
      client_developer_email: nil,
      client_cert_file: nil,
      key_secret: 'notasecret',
      redirect_uri: nil,
    }

    def initialize(config, use_default = true)

      if use_default
        config = DEFAULT.merge(config)
      end

      config.each do |key, value|
        eval <<-METHOD
          def #{key}(value = nil, &block)
            if block_given?
              @#{key}.instance_eval(&block)
            end

            if value.nil?
              return @#{key}
            end

            self.#{key} = value
          end

          def #{key}=(value)
            @#{key} = value
          end
        METHOD

        self.send("#{key}=", value)
      end
    end

    def configure(&block)
      if block_given?
        yield self
      end

      self
    end
    
  end
end
