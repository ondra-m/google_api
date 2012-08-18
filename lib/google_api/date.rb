require "date"

module GoogleApi
  module Date

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

    def now
      Date.today
    end

    def prev_month
      Date.today.prev_month
    end

    def more_months?(d1, d2)

      d1 = Date.parse(d1) if d1.is_a?(String)
      d2 = Date.parse(d2) if d2.is_a?(String)

      d1.month != d2.month
    end

    def more_years?(d1, d2)

      d1 = Date.parse(d1) if d1.is_a?(String)
      d2 = Date.parse(d2) if d2.is_a?(String)

      d1.year != d2.year
    end

    def day_older?(date)
      
      if date.is_a?(String)
        date = Date.parse(date)
      end

      if (Date.today <=> date.to_date) > 0
        return true
      end

      return false
    end

  end
end
