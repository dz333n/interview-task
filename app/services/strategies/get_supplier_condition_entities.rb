module Strategies
  class GetSupplierConditionEntities < ApplicationService
    attr_reader :condition

    def initialize(condition)
      @condition = condition
    end

    def call
      PerformStrategyQuery.call(
        base_relation: Supplier,
        includes: {
          contract: :user
        },
        condition: condition
      )
    end
  end
end
