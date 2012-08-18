module GoogleApi
  module Ga
    module Helper

      # Same as get but automaticly add day, month and year to dimension
      #
      # Also check cache
      #
      def get_by_day(parameters, start_date = prev_month, end_date = now, expire = nil)
        
        [:dimensions, :sort].each do |param|
          parameters[param] = [] unless parameters[param]

          if parameters[param].is_a?(String) || parameters[param].is_a?(Symbol)
            parameters[param] = [parameters[param]]
          end
        end

        parameters[:dimensions] << :day

        if more_years?(start_date, end_date)
          parameters[:dimensions] << :month
          parameters[:dimensions] << :year

          parameters[:sort] << :year
          parameters[:sort] << :month

        elsif more_months?(start_date, end_date)
          parameters[:dimensions] << :month

          parameters[:sort] << :month
        end

        parameters[:sort] << :day

        get(parameters, start_date, end_date, expire)
      end

    end
  end
end
