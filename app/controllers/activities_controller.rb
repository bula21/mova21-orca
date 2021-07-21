# frozen_string_literal: true

class ActivitiesController < ApplicationController
  load_and_authorize_resource except: [:create]

  def index
    @activities = filter.apply(Activity.accessible_by(current_ability).distinct).page params[:page]
  end

  def show; end

  def new
    @activity = Activity.new
  end

  def edit; end

  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to @activity, notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to @activity, notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  def destroy
    if params[:attachment_id]
      delete_attachment
    elsif params[:picture_id]
      delete_picture
    else
      @activity.destroy
      redirect_to activities_url, notice: I18n.t('messages.deleted.success')
    end
  end

  private

  def delete_picture
    @activity.picture.purge
    redirect_to edit_activity_url(@activity)
  end

  def delete_attachment
    @activity.activity_documents.find_by(id: params[:attachment_id]).purge
    redirect_to edit_activity_url(@activity)
  end

  def filter
    activity_filter_params = params[:activity_filter]&.permit(:min_participants_count, :stufe_recommended, :text,
                                                              :activity_category, tags: [], languages: [])
    session[:activity_filter_params] = activity_filter_params if params.key?(:activity_filter)
    @filter ||= ActivityFilter.new(session[:activity_filter_params] || {})
  end

  def activity_params
    params.require(:activity).permit(:label, :description, :block_type, :simo, :participants_count_activity,
                                     :participants_count_transport, :duration_activity, :duration_journey, :location,
                                     :transport_location_id, :min_participants, :activity_type, :activity_category_id,
                                     :picture, :language_de, :language_en, :language_fr, :language_it,
                                     I18n.available_locales.map { |l| :"label_#{l}" },
                                     I18n.available_locales.map { |l| :"description_#{l}" },
                                     stufe_ids: [], stufe_recommended_ids: [], goal_ids: [], tag_ids: [],
                                     activity_documents: [])
  end
end
