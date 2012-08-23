module GoogleApi
  module Shorten
    class Get < Url

      attr_reader :short_url
      attr_reader :projection
      attr_reader :data

      PROJECTION_LIST = ['FULL', 'ANALYTICS_CLICKS', 'ANALYTICS_TOP_STRINGS']

      def initialize(short_url, projection)
        @short_url  = short_url
        @projection = projection.upcase

        unless PROJECTION_LIST.include?(projection)
          raise GoogleApi::ShortenError, "Invalid projection. Must be #{PROJECTION_LIST.join(',')}."
        end

        get
      end

      private

        def get
          @data = JSON.parse(_session.client.execute( api_method: _session.api.url.get,
                                           parameters: { shortUrl: @short_url,
                                                         projection: @projection } ).response.env[:body])
        end
      
    end
  end
end
