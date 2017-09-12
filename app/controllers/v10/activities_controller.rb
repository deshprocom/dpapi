module V10
  class ActivitiesController < ApplicationController
    def index
      @activities = Activity.order(activity_time: :desc).limit(50)
    end

    def show
      @activity = Activity.find(params[:id])
    end

    def pushed
      @activity = Activity.find_by!(pushed: true)
      render 'show'
    end
  end
end