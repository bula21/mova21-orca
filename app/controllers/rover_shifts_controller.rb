# frozen_string_literal: true

class RoverShiftsController < ApplicationController
  load_and_authorize_resource :rover_shift

  def index
    @job_id = params[:job_id].presence

    @rover_shifts = @job_id ? @rover_shifts.where(job_id: @job_id) : RoverShift.none
    return unless @job_id

    @activity_executions = ActivityExecution.ordered_by_rover_shift_prio.joins(:activity)
                                            .where(activities: { rover_job_id: @job_id })
  end

  def new; end

  def create
    @import = RoverShiftsImport.new(**params.require(:import).permit(:file, :job_id).to_h.symbolize_keys)

    if @import.call
      redirect_to rover_shifts_path(job_id: @import.job_id), notice: I18n.t('messages.import.success')
    else
      render 'new'
    end
  end

  def update_dependent
    activity_execution_id = params.dig(:item, :activityExecutionId)
    prev_rover_shift_id = params.dig(:from, :roverShiftId)
    new_rover_shift_id = params.dig(:to, :roverShiftId)

    ActivityExecutionRoverShift.replace(prev_rover_shift_id, new_rover_shift_id, activity_execution_id)

    head :no_content
  end
end
