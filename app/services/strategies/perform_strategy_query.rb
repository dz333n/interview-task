module Strategies
  class PerformStrategyQuery < ApplicationService
    attr_reader :base_relation, :includes, :condition

    def initialize(base_relation:, includes:, condition:)
      @base_relation = base_relation
      @includes = includes
      @condition = condition
    end

    def call
      base_relation.includes(includes).select { |entity| eval(formula) }.uniq
    end

    def formula
      condition.formula.gsub(base_relation.to_s, "entity")
    end
  end
end
