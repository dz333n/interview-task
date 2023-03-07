module Strategies
  class GetContractConditionEntities < ApplicationService
    attr_reader :condition

    def initialize(condition)
      @condition = condition
    end

    def call
      PerformStrategyQuery.call(
        base_relation: Contract,
        includes: %i[user supplier],
        condition: condition
      )
    end
  end
end
