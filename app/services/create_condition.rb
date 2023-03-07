class CreateCondition < ApplicationService
  attr_reader :formula

  def initialize(formula)
    @formula = formula
  end

  def call
    Condition.create!(formula: formula)
  end
end
