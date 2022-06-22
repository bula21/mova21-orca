# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class ActivityExecutionsController < ApplicationController
  load_and_authorize_resource :activity
  load_and_authorize_resource through: :activity, shallow: true
  before_action :set_spots, only: %i[index show]

  def index
    @activity_executions = filter.cached(@activity_executions.includes(:activity, :unit_activity_executions,
                                                                       field: :spot).ordered)
    @activity_executions = ActivityExecution.none unless filter.active?

    respond_to do |format|
      format.html
      if params[:export] == "units"
        format.csv { send_exported_data_with_units(@activity_executions) }
      else
        format.csv { send_exported_data_without_units(@activity_executions) }
      end
      format.json { render json: ActivityExecutionBlueprint.render(@activity_executions, view: :with_fields) }
    end
  end

  def create
    respond_to do |format|
      if @activity_execution.save
        format.html { redirect_to activity_execution_path(@activity_execution), notice: t('messages.created.success') }
        format.json { render status: :ok, json: json_response(@activity_execution, ok: true) }
      else
        format.html { render :new, alert: t('messages.updated.error') }
        format.json { render status: :bad_request, json: json_response(@activity_execution, ok: false) }
      end
    end
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @activity_execution.update(activity_execution_params)
        format.html { redirect_to activity_execution_path(@activity_execution), notice: t('messages.updated.success') }
        format.json { render status: :ok, json: json_response(@activity_execution, ok: true) }
      else
        format.html { render :edit, alert: t('messages.updated.error') }
        format.json { render status: :bad_request, json: json_response(@activity_execution, ok: false) }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @activity_execution.destroy
        format.html { redirect_to activity_executions_path, notice: t('messages.deleted.success') }
        format.json { render status: :ok, json: { success: true, data: nil } }
      else
        format.html { render :edit, alert: t('messages.deleted.error') }
        format.json { render status: :bad_request, json: { success: false } }
      end
    end
  end

  def import
    if params[:import].nil?
      redirect_to activity_activity_executions_path(@activity),
                  flash: { error: I18n.t('activity_execution.import.no_file_selected') }
      return
    end
    handle_import
  rescue TypeError
    redirect_to activity_activity_executions_path(@activity),
                flash: { error: I18n.t('activity_execution.import.invalid_file_type') }
  end

  private

  def handle_import
    import_service = ActivityExecutionsImport.new(params.require(:import).permit(:file)[:file], @activity)
    if import_service.call
      redirect_to activity_activity_executions_path(@activity),
                  flash: { success: I18n.t('activity_execution.import.success',
                                           count: import_service.imported_items_count) }
    else
      @import_errors = import_service.errors
      render 'import'
    end
  end

  def set_activity_executions
    @activity_executions = filter.cached(@activity_executions.includes(:activity, :unit_activity_executions,
                                                                       field: :spot).ordered)
    @activity_executions = ActivityExecution.none unless filter.active?
  end

  def json_response(activity_execution, ok:)
    if ok
      { success: ok, data: ActivityExecutionBlueprint.render_as_hash(activity_execution) }
    else
      { success: ok, errors: activity_execution.errors.full_messages }
    end
  end

  def filter
    @filter ||= ActivityExecutionFilter.new(filter_params).tap do |filter|
      filter.activity_id = @activity.id if @activity
    end
  end

  def set_spots
    @spots = Spot.all.includes(:fields).ordered
  end

  def activity_execution_params
    params.require(:activity_execution).permit(:starts_at, :ends_at, :field_id, :spot_id, :change_notification,
                                               :amount_participants, :transport_ids, :transport, :change_remarks,
                                               :language_de, :language_fr, :language_it, :language_en,
                                               :mixed_languages, languages: []).tap do |params|
      convert_language_array_to_flags(params) if params[:languages]
    end
  end

  def filter_params
    params[:activity_execution_filter]&.permit(%i[spot_id field_id starts_at_after ends_at_before activity_id
                                                  min_available_headcount max_units date language])
  end

  def send_exported_data_without_units(activity_executions)
    exporter = ActivityExecutionExporter.new(activity_executions)
    send_data exporter.export, filename: exporter.filename
  end

  def send_exported_data_with_units(activity_executions)
    exporter = UnitActivityExecutionsExporter.new(activity_executions)
    send_data exporter.export, filename: exporter.filename
  end

  def convert_language_array_to_flags(params)
    Activity::LANGUAGES.each do |language|
      params[language] = params[:languages].include? language.to_s.sub('language_', '')
    end
    params.delete('languages')
  end
end
# rubocop:enable Metrics/ClassLength
