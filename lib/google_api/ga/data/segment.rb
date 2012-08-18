module GoogleApi
  module Ga
    class Segment < DataDsl
      
      def join
        "dynamic::" + build_parameter
      end

    end
  end
end
