# frozen_string_literal: true

class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!
  load_and_authorize_resource except: [:create]

  def index
    @activities = filter.apply(Activity.accessible_by(current_ability).distinct)
    respond_to do |format|
      format.html { @activities = @activities.page params[:page] }
      format.json { render json: ActivityBlueprint.render(@activities) }
    end
  end

  def show
    @spots = SpotBlueprint.render_as_hash Spot.all
  end

  def new
    @activity = Activity.new
  end

  def edit; end

  def create
    @activity = Activity.new(activity_params)
    attach_attachments

    if @activity.save
      redirect_to @activity, notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def update
    attach_attachments
    if @activity.update(activity_params)
      redirect_to @activity, notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to activities_url, notice: I18n.t('messages.deleted.success')
  end

  def delete_attachment
    type = params[:type]&.to_sym
    if Activity::ATTACHMENTS.include?(type)
      attachment = @activity.send(type)
      attachment = attachment.find_by(id: params[:attachment_id]) if params[:attachment_id].present?
      attachment.purge if attachment.respond_to?(:purge)
    end
    redirect_to edit_activity_url(@activity)
  end

  private

  def attach_attachments
    %i[language_documents_de language_documents_fr language_documents_it activity_documents].each do |attachment|
      next if params[:activity][attachment].blank?

      @activity.send(attachment).attach(params[:activity][attachment])
    end
  end

  def filter
    activity_filter_params = params[:activity_filter]&.permit(:min_participants_count, :stufe_recommended, :text,
                                                              :activity_category, tags: [], languages: [])
    session[:activity_filter_params] = activity_filter_params if params.key?(:activity_filter)
    @filter ||= ActivityFilter.new(session[:activity_filter_params] || {})
  end

  def activity_params
    params.require(:activity)
          .permit(:label, :description, :block_type, :simo, :participants_count_activity, :participants_count_transport,
                  :duration_activity, :duration_journey, :location, :transport_location_id, :min_participants,
                  :activity_type, :activity_category_id, :picture,
                  I18n.available_locales.map { |l| ["label_#{l}", "description_#{l}", "language_#{l}"] }.flatten,
                  stufe_ids: [], stufe_recommended_ids: [], goal_ids: [], tag_ids: [], activity_documents: [])
  end
end
