module GoogleApi
  module Ga
    class Goal < Management

      attr_reader :account_id
      attr_reader :webproperty_id
      attr_reader :profile_id
      attr_reader :value
      attr_reader :active
      attr_reader :type
      attr_reader :goal

      def initialize(goal)
        set(goal)
      end

      def self.all(account_id = '~all', webproperty_id = '~all', profile_id = '~all', goal_id = '~all')
        get({ accountId: account_id, webPropertyId: webproperty_id, profileId: profile_id, goalId: goal_id }).map { |goal| Goal.new(goal) }
      end

      def self.find(goal_id)
        all('~all', '~all', '~all', goal_id).first
      end

      def refresh
        @profile  = nil

        set( Goal.get({ accountId: @account_id, webPropertyId: @webproperty_id, profileId: @profile_id, goalId: @id }).first )

        return true
      end

      def profile
        @profile ||= Profile.find(@profile_id)
      end

      private

        def self.get(parameters = nil)
          super(@@session.api.management.goals.list, parameters)
        end

        def set(goal)
          @account_id     = goal['accountId']
          @webproperty_id = goal['webPropertyId']
          @profile_id     = goal['profileId']
          @value          = goal['value']
          @active         = goal['active']
          @type           = goal['type']

          @goal = goal[camelize(@type) + 'Details']

          super(goal)
        end
      
    end
  end
end
