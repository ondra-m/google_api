module GoogleApi
  module Ga
    class DataDsl

      OPERATORS = ['==', '!=', '>', '<', '>=', '<=', '=~', '!~']
      OPERATORS_METHOD =  {'%' => '=@', '**' => '!@'}

      def initialize
        @result = []
      end

      # Make operators 
      OPERATORS.each do |operator|
        eval <<-METHOD
          def #{operator} (value)
            @result << @attribute + "#{operator}" + value.to_s
            self
          end
        METHOD
      end
      OPERATORS_METHOD.each do |key, value|
        eval <<-METHOD
          def #{key} (value)
            @result << @attribute + "#{value}" + value.to_s
            self
          end
        METHOD
      end

      def method_missing(name)
        if name.to_s =~ /\A[a-zA-Z0-9]+\Z/
          @attribute = "ga:#{name}"
          self
        else
          super
        end
      end

      def &(other)
        @result << :and
        self
      end

      def |(other)
        @result << :or
        self
      end

      def build_parameter
        i = @result.index{ |x| x.is_a?(Symbol) }

        if !i.nil?
          result = @result[i-2] + (@result[i] == :and ? ";" : ",") + @result[i-1]
          @result.delete_at(i)
          @result.delete_at(i-1)
          @result[i-2] = result

          build_parameter
        else
          @result.join
        end
      end
      
    end
  end
end
