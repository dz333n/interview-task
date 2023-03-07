module Strategies
  class GetUserConditionEntities < ApplicationService
    attr_reader :condition

    def initialize(condition)
      @condition = condition
    end

    def call
      PerformStrategyQuery.call(
        base_relation: User,
        includes: {
          contract: :supplier
        },
        condition: condition
      )
    end
  end
end
