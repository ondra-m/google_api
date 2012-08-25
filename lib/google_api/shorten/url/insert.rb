module GoogleApi
  module Shorten
    class Insert < Url

      attr_reader :long_url
      attr_reader :short_url

      def initialize(long_url)
        @long_url = long_url

        @short_url = _session.check_session ? get : get_without_login
      end

      def details(projection = 'FULL')
        Shorten.get(@short_url, projection)
      end

      private

        def get
          _session.client.execute( api_method: _session.api.url.insert,
                                   body: { longUrl: @long_url }.to_json, 
                                   headers: {'Content-Type' => 'application/json'} ).data.id
        end

        def get_without_login
          require 'net/http'
          require 'json'

          uri = URI(Shorten::URLSHORTENER_URI)

          req = Net::HTTP::Post.new(uri.path)
          req.body = {longUrl: @long_url}.to_json
          req.content_type = 'application/json'

          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
          end

          JSON.parse(res.body)['id']
        end
      
    end
  end
end
