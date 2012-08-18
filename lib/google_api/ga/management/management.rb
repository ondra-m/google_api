module GoogleApi
  module Ga
    class Management

      @@session = Session

      attr_reader :id
      attr_reader :name
      attr_reader :created
      attr_reader :updated

      def camelize(string)
        string = string.downcase.split('_').map!(&:capitalize).join
        string[0] = string[0].downcase
        string
      end

      protected
      
        def self.get(api_method, parameters = nil)
          JSON.parse( 
            @@session.client.execute(api_method: api_method,
                                     parameters: parameters).body
          )["items"]
        end

        def set(values)
          @id      = values['id']
          @name    = values['name']
          @created = values['created']
          @updated = values['updated']
        end

    end
  end
end
