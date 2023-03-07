class GetconditionBaseObject < ApplicationService
  attr_reader :condition

  def initialize(condition)
    @condition = condition
  end

  def call
    unless condition.formula.include?(".")
      raise StandardError.new("Unable to parse the formula")
    end

    condition.formula.strip.split(".").first
  end
end
