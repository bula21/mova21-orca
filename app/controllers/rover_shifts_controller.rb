# frozen_string_literal: true

class RoverShiftsController < ApplicationController
  load_and_authorize_resource :rover_shift

  def index
    @matcher = RoverShiftMatcher.new(333).call
  end

  def new
  end

  def create
    @import = RoverShiftsImport.new(**params.require(:import).permit(:file, :job_id).to_h.symbolize_keys)

    if @import.call
      redirect_to rover_shifts_path, notice: I18n.t('messages.import.success')
    else
      render 'index'
    end
  end
end
