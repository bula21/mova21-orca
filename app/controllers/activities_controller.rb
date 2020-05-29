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
    if params[:attachment_id]
      @activity.activity_documents.find_by_id(params[:attachment_id]).purge
      redirect_to edit_activity_url(@activity)
    else
      @activity.destroy
      redirect_to activities_url, notice: 'Activity was successfully destroyed.'
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:label, :description, :language, :block_type, :simo, :participants_count_activity,
                                     :participants_count_transport, :duration_activity, :duration_journey, :location,
                                     I18n.available_locales.map { |l| :"label_#{l}" },
                                     I18n.available_locales.map { |l| :"description_#{l}" },
                                     stufe_ids: [], stufe_recommended_ids: [], goal_ids: [], tag_ids: [],
                                     activity_documents: [])
  end
end
