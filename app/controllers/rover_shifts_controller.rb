# frozen_string_literal: true

class RoverShiftsController < ApplicationController
  load_and_authorize_resource :rover_shift

  def index
    @job_id = params[:job_id].presence

    return unless @job_id

    @rover_shifts = @rover_shifts.where(job_id: @job_id)
    @matcher = RoverShiftMatcher.new(@job_id).call
    @activity_executions = ActivityExecution.ordered_by_rover_shift_prio.joins(:activity)
                                            .where(activities: { rover_job_id: @job_id })
  end

  def new; end

  def create
    @import = RoverShiftsImport.new(**params.require(:import).permit(:file, :job_id).to_h.symbolize_keys)

    if @import.call
      redirect_to rover_shifts_path, notice: I18n.t('messages.import.success')
    else
      render 'index'
    end
  end
end
