module GoogleApi
  module Ga
    class Profile < Management

      attr_reader :accountId
      attr_reader :webPropertyId
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

        set( Profile.get({ accountId: @accountId, webPropertyId: @webPropertyId, profileId: @id }).first )

        return true
      end

      def webproperty
        @webproperty ||= Webproperty.find(@webpropertyId)
      end

      def goals
        @goals ||= Goal.all(@accountId, @webPropertyId, @id)
      end

      # def get(parameters, start_date = prev_month, end_date = now, expire = nil)
      #   Data.get(@id, parameters, start_date, end_date, expire)
      # end

      # def get!(parameters, start_date = prev_month, end_date = now)
      #   Data.get!(@id, parameters, start_date, end_date)
      # end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.profiles.list, parameters)
        end

        def set(profile)
          @accountId     = profile['accountId']
          @webPropertyId = profile['webPropertyId']
          @currency      = profile['currency']
          @timezone      = profile['timezone']

          super(profile)
        end
      
    end
  end
end
