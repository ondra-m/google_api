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

        @data = _session.check_session ? get : get_without_login
      end

      private

        def get
          JSON.parse(_session.client.execute( api_method: _session.api.url.get,
                                              parameters: { shortUrl: @short_url,
                                                            projection: @projection } ).body)
        end

        def get_without_login
          require 'net/http'
          require 'json'

          uri = URI(Shorten::URLSHORTENER_URI)
          uri.query = URI.encode_www_form({ shortUrl: @short_url,
                                            projection: @projection })

          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            req = Net::HTTP::Get.new(uri.request_uri)

            http.request(req)
          end

          JSON.parse(res.body)
        end

    end
  end
end
