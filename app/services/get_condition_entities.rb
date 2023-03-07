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
    strategy = STRATEGIES[base_object.to_sym]

    validate_absent_strategy!(base_object, strategy)

    strategy.call(condition)
  end

  def validate_absent_strategy!(base_object, strategy)
    if strategy.nil?
      raise StandardError.new("The base object (#{base_object}) is unknown")
    end
  end
end
