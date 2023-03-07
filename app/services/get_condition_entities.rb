class GetConditionEntities < ApplicationService
  attr_reader :condition

  STRATEGIES = {
    User: Strategies::GetUserConditionEntities,
    Contract: Strategies::GetContractConditionEntities,
    Supplier: Strategies::GetSupplierConditionEntities
  }

  def initialize(condition)
    @condition = condition
  end

  def call
    base_object = GetConditionBaseObject.call(condition)
    strategy = STRATEGIES[base_object]

    validate_absent_strategy!(strategy)

    strategy.call(condition)
  end

  def validate_absent_strategy!(strategy)
    if strategy.nil?
      raise StandardError.new("The base object (#{base_object}) is unknown")
    end
  end
end
