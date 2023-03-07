module Strategies
  class GetContractConditionEntities < ApplicationService
    attr_reader :condition

    def initialize(condition)
      @condition = condition
    end

    def call
    end
  end
end
