module GoogleApi
  module Ga
    class Data

      def initialize
        @ids, @cache = nil, nil
        @start_date, @end_date = Date.today, Date.today
        @metrics, @dimensions, @sort = [], [], []
        @filters, @segment = nil, nil
        @start_index, @max_results = nil, nil
      end

      # Auto initialize data 
      def self.method_missing(method, *args, &block)
        if block_given?
          new.send(method, &block)
        else
          new.send(method, *args)
        end
      end

      # Convert string, DateTime and Time to date
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

      # Clear value 
      def clear
        @header     = nil
        @parameters = nil
        @data       = nil
        @all        = nil
      end

      # -----------------------------------------------------------------------------------
      # Type 1, all are integer
      #
      # Ids, Cache, Start index, Max results
      #
      #          name,        alias
      #
      TYPE_1 = { ids:         :id,
                 cache:       nil,
                 start_index: :offset,
                 max_results: :limit }

      TYPE_1.each do |key, value|
        eval <<-METHOD
          def #{key}(value = nil)
            if value.nil?
              return @#{key}
            end

            self.#{key} = value
            self
          end

          def #{key}=(value)
            type?(value, Integer)

            @#{key} = value
          end
        METHOD

        unless value.nil?
          eval <<-METHOD
            alias :#{value}  :#{key}
            alias :#{value}= :#{key}=
          METHOD
        end
      end

      # -----------------------------------------------------------------------------------
      # Type 2, date
      #
      # Start date, End date
      #
      #          name,       alias
      #
      TYPE_2 = { start_date: :from,
                 end_date:   :to }

      TYPE_2.each do |key, value|
        eval <<-METHOD
          def #{key}(date = nil)
            if date.nil?
              return @#{key}
            end

            self.#{key} = date
            self
          end

          def #{key}=(date)
            if date.is_a?(Integer)
              @#{key} += date
            else
              @#{key} = to_date(date)
            end
          end
        METHOD

        unless value.nil?
          eval <<-METHOD
            alias :#{value}  :#{key}
            alias :#{value}= :#{key}=
          METHOD
        end
      end

      # -----------------------------------------------------------------------------------
      # Type 3
      #
      # Metrics, Dimensions, Sort
      #
      #          name,       alias
      #
      TYPE_3 = { metrics:    :select,
                 dimensions: :with,
                 sort:       nil }

      TYPE_3.each do |key, value|
        eval <<-METHOD
          def #{key}(*args)
            if args.size == 0
              return @#{key}
            end

            self.#{key} = args
            self
          end

          def #{key}=(value)
            clear
            @#{key} = build_param(value)
          end

          def #{key}_add(*args)
            if args.size == 0
              return @#{key}
            end

            self.#{key}_add = args
            self
          end

          def #{key}_add=(value)
            clear
            @#{key} += build_param(value)
          end

          def #{key}_sub(*args)
            if args.size == 0
              return @#{key}
            end
            
            self.#{key}_sub = args
            self
          end

          def #{key}_sub=(value)
            clear
            @#{key} -= build_param(value)
          end
        METHOD

        unless value.nil?
          eval <<-METHOD
            alias :#{value}  :#{key}
            alias :#{value}= :#{key}=

            alias :#{value}_add  :#{key}_add
            alias :#{value}_add= :#{key}_add=

            alias :#{value}_sub  :#{key}_sub
            alias :#{value}_sub= :#{key}_sub=
          METHOD
        end
      end

      # -----------------------------------------------------------------------------------
      # Type 4
      #
      # Filters, Segment
      #
      #          name,       alias
      #
      TYPE_4 = { filters: :where,
                 segment: nil }

      TYPE_4.each do |key, value|
        eval <<-METHOD
          def #{key}(value = nil, &block)
            if !block_given? && value.nil?
              return @#{key}
            end

            if block_given?
              @#{key} = #{key.to_s.capitalize}Dsl.new.instance_eval(&block).join
            else
              @#{key} = value
            end
            self
          end
        METHOD

        unless value.nil?
          eval <<-METHOD
            alias :#{value} :#{key}
          METHOD
        end
      end

      # Add row!, header!, all!, count!. First clear and run method .
      [:rows, :header, :all, :count].each do |value|
        eval <<-METHOD
          def #{value}!
            clear
            #{value}
          end
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
        if block.arity == 1 # each
          rows.each do |row|
            yield(row)
          end
        else                # each with index
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

        def data
          @data ||= get.data
        end

        def parameters
          return @parameters if @parameters

          if @ids.nil?
            self.ids = Ga.id
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

        def get
          if @cache && _cache.exists?(parameters)
            return _cache.read(parameters)
          end

          result = _session.client.execute( api_method: _session.api.data.ga.get,
                                            parameters: parameters )

          _cache.write(parameters, result, @cache) if @cache.is_a?(Integer)

          result
        end
      
    end
  end
end
