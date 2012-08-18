module GoogleApi
  module Ga
    class Webproperty < Management

      attr_reader :accountId
      attr_reader :websiteUrl

      def initialize(webproperty)
        set(webproperty)
      end

      def self.all(account_id = '~all', webproperty_id = '~all')
        get({ accountId: account_id, webPropertyId: webproperty_id }).map { |webproperty| Webproperty.new(webproperty) }
      end

      def self.find(webproperty_id)
        all('~all', webproperty_id).first
      end

      def refresh
        @account  = nil
        @profiles = nil

        set( Webproperty.get({ accountId: @accountId, webPropertyId: @id }).first )

        return true
      end

      def account
        @account ||= Account.find(@accountId)
      end

      def profiles
        @profiles ||= Profile.all(@accountId, @id)
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.webproperties.list, parameters)
        end

        def set(webproperty)
          @accountId  = webproperty['accountId']
          @websiteUrl = webproperty['websiteUrl']

          super(webproperty)
        end
      
    end
  end
end
