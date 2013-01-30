module GoogleApi
  module Ga
    class Profile < Management

      attr_reader :account_id
      attr_reader :webproperty_id
      attr_reader :currency
      attr_reader :timezone

      def initialize(profile)
        set(profile)
      end

      def self.all(account_id = '~all', webproperty_id = '~all', profile_id = '~all')
        get({ accountId: account_id, webPropertyId: webproperty_id, profileId: '~all' }).map { |profile| Profile.new(profile) }
      end

      def self.find(profile_id)
        all('~all', '~all', profile_id).first
      end

      def refresh
        @webproperty = nil
        @goals       = nil

        set( Profile.get({ accountId: @account_id, webPropertyId: @webproperty_id, profileId: @id }).first )

        return true
      end

      def webproperty
        @webproperty ||= Webproperty.find(@webproperty_id)
      end

      def goals
        @goals ||= Goal.all(@account_id, @webproperty_id, @id)
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.profiles.list, parameters)
        end

        def set(profile)
          @account_id     = profile['accountId']
          @webproperty_id = profile['webPropertyId']
          @currency       = profile['currency']
          @timezone       = profile['timezone']

          super(profile)
        end
      
    end
  end
end
