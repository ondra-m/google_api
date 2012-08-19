module GoogleApi
  module Ga
    class SegmentDsl < DataDsl
      
      def join
        "dynamic::" + build_parameter
      end

    end
  end
end
