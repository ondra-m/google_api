module GoogleApi
  module Ga
    class Account < Management

      def initialize(account)
        set(account)
      end

      def self.all(account_id = '~all')
        get({ accountId: account_id }).map { |account| Account.new(account) }
      end

      def self.find(account_id)
        all(account_id).first
      end

      def refresh
        @webproperties = nil

        set( Account.get({ accountId: @id }).first )

        return true
      end

      def webproperties
        @webproperties ||= Webproperty.all(@id)
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.accounts.list, parameters)
        end
      
    end
  end
end
