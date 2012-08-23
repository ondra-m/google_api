module GoogleApi
  module Shorten
    class Insert < Url

      attr_reader :long_url
      attr_reader :short_url

      def initialize(long_url)
        @long_url = long_url

        get
      end

      def details(projection = 'FULL')
        Shorten.get(@short_url, projection)
      end

      private

        def get
          @short_url = _session.client.execute( api_method: _session.api.url.insert,
                                                body: { longUrl: @long_url }.to_json, 
                                                headers: {'Content-Type' => 'application/json'} ).data.id
        end
      
    end
  end
end
