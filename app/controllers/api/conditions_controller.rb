module Api
  class ConditionsController < ApplicationController
    def create
      condition = CreateCondition.call(params[:formula])
      render json: condition
    end

    def entities
      condition = Condition.find!(params[:condition_id])
      entities = GetConditionEntities.call(condition: condition)

      render json: entities
    end
  end
end
