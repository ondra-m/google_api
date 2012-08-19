module GoogleApi
  module Ga
    class Segment < Management

      attr_accessor :segmentId
      attr_accessor :definition

      def initialize(segment)
        set(segment)
      end

      def self.all(segment_id = '~all')
        get({ segmentId: segment_id }).map { |segment| Segment.new(segment) }
      end

      def self.find(segment_id)
        all(segment_id).first
      end

      def refresh
        set( Segment.get({ segmentId: @id }).first )

        return true
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.segments.list, parameters)
        end
        
        def set(segment)
          @segmentId  = segment['segmentId']
          @definition = segment['definition']

          super(segment)
        end
      
    end
  end
end
