# frozen_string_literal: true

class ActivitiesController < ApplicationController
  skip_before_action :authenticate_user!
  load_and_authorize_resource except: [:create]

  def index
    activity_includes = [:activity_category, :stufen, :stufe_recommended,
                         { activity_executions: %i[field spot unit_activity_executions] }]
    @activities = Activity.accessible_by(current_ability).includes(activity_includes)
    @activities = filter.apply(@activities.distinct).order(sort_direction)
    respond_to do |format|
      format.html { @activities = @activities.page params[:page] }
      format.json { render json: ActivityBlueprint.render(@activities, view: :with_activity_executions) }
    end
  end

  def show; end

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
      attachment = @activity.public_send(type)
      attachment = attachment.find_by(id: params[:attachment_id]) if params[:attachment_id].present?
      attachment.purge if attachment.respond_to?(:purge)
    end
    redirect_to edit_activity_url(@activity)
  end

  private

  def sort_direction
    return :id unless params[:sort]
    return { id: :desc } if params[:sort] == 'id_desc'
    return :label if params[:sort] == 'label'
    return { label: :desc } if params[:sort] == 'label_desc'
  end

  def attach_attachments
    %i[language_documents_de language_documents_fr language_documents_it activity_documents].each do |attachment|
      next if params[:activity][attachment].blank?

      @activity.public_send(attachment).attach(params[:activity][attachment])
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
                  :duration_activity, :duration_journey, :location, :transport_location_id, :min_participants, :picture,
                  :activity_type, :activity_category_id, :rover_job_id, :rover_shift_prio, :required_rovers,
                  I18n.available_locales.map { |l| ["label_#{l}", "description_#{l}", "language_#{l}"] }.flatten,
                  stufe_ids: [], stufe_recommended_ids: [], goal_ids: [], tag_ids: [])
  end
end
