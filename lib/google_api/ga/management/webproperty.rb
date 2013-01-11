module GoogleApi
  module Ga
    class Webproperty < Management

      attr_reader :account_id
      attr_reader :website_url

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

        set( Webproperty.get({ accountId: @account_id, webPropertyId: @id }).first )

        return true
      end

      def account
        @account ||= Account.find(@account_id)
      end

      def profiles
        @profiles ||= Profile.all(@account_id, @id)
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.webproperties.list, parameters)
        end

        def set(webproperty)
          @account_id  = webproperty['accountId']
          @website_url = webproperty['websiteUrl']

          super(webproperty)
        end
      
    end
  end
end
