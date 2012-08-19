module GoogleApi
  class Configuration

    def initialize(config = {})
      config.each do |key, value|
        eval <<-METHOD
          def #{key}=(value)
            @#{key} = value
          end

          def #{key}(value = nil, &block)
            if block_given?
              @#{key}.instance_eval(&block)
            end

            if value.nil?
              return @#{key}
            end

            self.#{key} = value
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
