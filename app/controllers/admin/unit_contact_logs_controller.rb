# frozen_string_literal: true

module Admin
  class UnitContactLogsController < ApplicationController
    def show
      authorize!(:manage, :all)
      @logs = UnitContactLog.all.order(created_at: :desc).includes([:user]).page params[:page]
    end
  end
end
