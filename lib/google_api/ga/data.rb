module GoogleApi
  module Ga
    class Data

      # Initialize ----------------------------------------------------------------------------------

      def initialize
        @ids, @cache = nil, nil
        @start_date, @end_date = Date.today, Date.today
        @metrics, @dimensions, @sort = [], [], []
        @filters, @segment = nil, nil
        @start_index, @max_results = nil, nil
        @error = false
        @use_cache = true
      end

      # Auto initialize data 
      def self.method_missing(method, *args, &block)
        if block_given?
          new.send(method, &block)
        else
          new.send(method, *args)
        end
      end

      # Parameters for google analytics -------------------------------------------------------------

      TYPE_INTEGER = { ids: 'id',
                       cache: nil,
                       start_index: 'offset',
                       max_results: 'limit' }

      TYPE_DATE = { start_date: 'from',
                    end_date: 'to' }

      TYPE_ARRAY = { metrics: 'select',
                     dimensions: 'with',
                     sort: nil }

      TYPE_BLOCK = { filters: 'where',
                     segment: nil }

      TYPE_BOOLEAN = { error: nil,
                       use_cache: nil }

      # Create a base method
      # ids, cache, start_index, max_results, start_date, end_date, error, use_cache
      #
      # Example:
      #
      #   def ids(value = nil)
      #     if value.nil?
      #       return @ids
      #     end
      #
      #     self.ids = value
      #     self
      #   end
      #
      def self.create_base_method(name)
        eval <<-METHOD
          def #{name}(value = nil)
            if value.nil?
              return @#{name}
            end

            self.#{name} = value
            self
          end
        METHOD
      end

      # Create an array method, suffix is for _add or _sub 
      # metrics, dimensions, sort
      #
      # Example:
      #
      #   def metrics(*args)
      #     if args.empty?
      #       return @metrics
      #     end
      #
      #     self.metrics = args
      #     self
      #   end
      #
      #   def metrics=(value)
      #     clear
      #     @metrics = build_param(value)
      #   end
      #
      def self.create_array_method(name, operator = '', suffix = '')
        eval <<-METHOD
          def #{name}#{suffix}(*args)
            if args.empty?
              return @#{name}
            end

            self.#{name}#{suffix} = args
            self
          end

          def #{name}#{suffix}=(value)
            clear
            @#{name} #{operator}= build_param(value)
          end
        METHOD
      end

      # Create a base alias
      # ids, cache, start_index, max_results, start_date, end_date, metrics, dimensions, sort
      #
      # Example:
      #
      #   alias :id  :ids
      #   alias :id= :ids=
      #
      def self.create_base_alias(name, method_alias, suffix = '')
        unless method_alias.nil?
          eval <<-METHOD
            alias :#{method_alias}#{suffix}  :#{name}#{suffix}
            alias :#{method_alias}#{suffix}= :#{name}#{suffix}=
          METHOD
        end
      end

      # ids, cache, start_index, max_results
      TYPE_INTEGER.each do |name, method_alias|
        create_base_method(name)

        eval <<-METHOD
          def #{name}=(value)
            clear
            @#{name} = value.to_i
          end
        METHOD

        create_base_alias(name, method_alias)
      end

      # start_date, end_date
      TYPE_DATE.each do |name, method_alias|
        create_base_method(name)

        eval <<-METHOD
          def #{name}=(value)
            clear
            if value.is_a?(Integer)
              @#{name} += value
            else
              @#{name} = to_date(value)
            end
          end
        METHOD

        create_base_alias(name, method_alias)
      end

      # metrics, dimensions, sort
      TYPE_ARRAY.each do |name, method_alias|
        create_array_method(name)
        create_array_method(name, '+', '_add')
        create_array_method(name, '-', '_sub')

        create_base_alias(name, method_alias)
        create_base_alias(name, method_alias, '_add')
        create_base_alias(name, method_alias, '_sub')
      end

      # filters, segment
      TYPE_BLOCK.each do |name, method_alias|
        eval <<-METHOD
          def #{name}(value = nil, &block)
            if !block_given? && value.nil?
              return @#{name}
            end

            if block_given?
              @#{name} = #{name.to_s.capitalize}Dsl.new.instance_eval(&block).join
            else
              @#{name} = value
            end
            self
          end
        METHOD

        unless method_alias.nil?
          eval <<-METHOD
            alias :#{method_alias} :#{name}
          METHOD
        end
      end

      # error, user_cache
      TYPE_BOOLEAN.each do |name, method_alias|
        create_base_method(name)

        eval <<-METHOD
          def #{name}=(value)
            if !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
              raise GoogleApi::TypeError, "Value must be true of false"
            end

            @#{name} = value
          end
        METHOD
      end

      # Methods for manipulations with data ---------------------------------------------------------

      # Clear values 
      def clear
        @header     = nil
        @parameters = nil
        @data       = nil
        @all        = nil

        self
      end

      # Clear cache
      def clear_cache
        _cache.delete(parameters)
        self
      end

      # Add row!, header!, all!, count!. First clear and run normal method.
      [:rows, :header, :all, :count].each do |name|
        eval <<-METHOD
          def #{name}!; clear; #{name}; end
        METHOD
      end

      def rows
        data.rows
      end

      def header
        @header ||= data.column_headers.map { |c| c.name }
      end

      def count
        data.total_results
      end

      def all
        @all ||= [header, rows]
      end

      def each(&block)
        case block.arity
          # each
          when 1
            rows.each do |row|
              yield(row)
            end

          # each with index
          when 2
            i = -1
            rows.each do |row|
              i += 1
              yield(i, row)
            end
        end
      end

      def each!(&block)
        clear
        each(block)
      end

      private

        # Store data, call clear for fetch again
        def data
          @data ||= get
        end

        # Convert string, DateTime and Time to date for google analytics YYYY-MM-DD
        DATE_FORMAT = /\A[0-9]{4}-[0-9]{2}-[0-9]{2}\Z/

        def to_date(date)
          if date.is_a?(String)
            unless date =~ DATE_FORMAT
              raise GoogleApi::DateError, "Date: #{date} must match with #{DATE_FORMAT}."
            end

            date = Date.parse(date)
          end

          date.to_date
        end

        # Add prefix ga: to symbol in Array 
        def build_param(value)
          type?(value, Array)

          value.flatten.collect { |v| v.is_a?(Symbol) ? "ga:#{v}" : v }
        end

        # Check type 
        def type?(value, type)
          unless value.is_a?(type)
            raise GoogleApi::TypeError, "Value: #{value} must be #{type}."
          end
        end

        # Build and store parameters
        def parameters
          return @parameters if @parameters

          if @ids.nil?
            self.ids = Ga.id
          end

          if @ids.nil? || @ids == 0
            raise GoogleApi::GaError, "Ids is required."
          end

          @parameters = {}

          @parameters['ids']        = "ga:#{@ids}"
          @parameters['start-date'] = @start_date.to_s
          @parameters['end-date']   = @end_date.to_s
          @parameters['metrics']    = @metrics.join(',')

          @parameters['dimensions']  = @dimensions.join(',') unless @dimensions.empty?
          @parameters['sort']        = @sort.join(',')       unless @sort.empty?
          @parameters['filters']     = @filters              unless @filters.nil?
          @parameters['start-index'] = @start_index          unless @start_index.nil?
          @parameters['max-results'] = @max_results          unless @max_results.nil?

          @parameters
        end

        def _cache
          GoogleApi::Ga.cache
        end

        def _session
          Session
        end

        # Get data from google analytics
        def get
          if @use_cache && _cache.exists?(parameters)
            return _cache.read(parameters)
          end

          result = _session.client.execute( api_method: _session.api.data.ga.get,
                                            parameters: parameters )

          if @error && result.error?
            raise GoogleApi::GaError, result.error_message
          end

          result = result.data

          if @use_cache && !@cache.nil?
            _cache.write(parameters, result, @cache)
          end

          result
        end
      
    end
  end
end
