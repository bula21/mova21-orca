# frozen_string_literal: true

class ActivitiesController < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    @activities = Activity.all
  end

  def show; end

  def new
    @activity = Activity.new
  end

  def edit; end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to activities_url, notice: 'Activity was successfully destroyed.'
  end

  private

  def activity_params
    params.require(:activity).permit(:label, :description, :language, :js_type, :participants_count_activity,
                                     :participants_count_transport, :duration_activity, :duration_journey, :location,
                                     activity_documents: [])
  end
end
