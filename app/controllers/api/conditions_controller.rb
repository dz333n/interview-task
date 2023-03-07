module Api
    class ConditionsController < ApplicationController
        def create
            render json: { message: 'hello!' }
        end

        def entities; end
    end
end
