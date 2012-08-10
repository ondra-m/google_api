module GoogleApi
  class Configuration

    def initialize(config = {})
      config.each do |key, value|
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

        self.send("#{key}=", value)
      end
    end

    def configure(config = {})
      if block_given?
        yield self
      end

      self
    end
    
  end
end
