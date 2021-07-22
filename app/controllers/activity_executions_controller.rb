# frozen_string_literal: true

class ActivityExecutionsController < ApplicationController
  load_and_authorize_resource :activity
  load_and_authorize_resource through: :activity

  def index
    render json: ActivityExecutionBlueprint.render(@activity_executions)
  end

  def create
    @activity_execution = @activity.activity_executions.create(activity_execution_params)
    if @activity_execution.persisted?
      render status: :ok, json: { success: true, data: ActivityExecutionBlueprint.render_as_hash(@activity_execution) }
    else
      render status: :bad_request, json: { success: false, errors: @activity_execution.errors.full_messages }
    end
  end

  def update
    if @activity_execution.update(activity_execution_params)
      render status: :ok, json: { success: true, data: ActivityExecutionBlueprint.render_as_hash(@activity_execution) }
    else
      render status: :bad_request, json: { success: false, errors: @activity_execution.errors.full_messages }
    end
  end

  def destroy
    if @activity_execution.destroy
      render status: :ok, json: { success: true, data: nil }
    else
      render status: :bad_request, json: { success: false }
    end
  end

  private

  def activity_execution_params
    params.require(:activity_execution).permit(:starts_at, :ends_at, :field_id, :spot_id, :amount_participants,
                                               :transport, languages: []).tap do |params|
      convert_language_array_to_flags(params) if params[:languages]
    end
  end

  def convert_language_array_to_flags(params)
    Activity::LANGUAGES.each do |language|
      params[language] = params[:languages].include? language.to_s.sub('language_', '')
    end
    params.delete('languages')
  end
end
