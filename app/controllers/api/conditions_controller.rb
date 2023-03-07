module Api
  class ConditionsController < ApplicationController
    def create
      condition = CreateCondition.call(params[:formula])
      render json: condition
    end

    def entities
      condition = Condition.find(params[:condition_id])
      entities = GetConditionEntities.call(condition)

      render json: entities
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end
end
