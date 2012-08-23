module GoogleApi
  module Shorten
    class List < Url

      def initialize
        get
      end

      def count
        @data['totalItems']
      end

      def items
        @data['items']
      end

      private
        
        def get
          @data = JSON.parse(_session.client.execute( api_method: _session.api.url.list,
                                                      parameters: { projection: 'FULL' } ).response.env[:body])
        end

    end
  end
end
