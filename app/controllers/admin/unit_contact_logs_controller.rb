# frozen_string_literal: true

module Admin
  class UnitContactLogsController < ApplicationController
    load_and_authorize_resource :unit_contact_log

    def index
      @unit_contact_logs = @unit_contact_logs.order(created_at: :desc).includes(:user).page(params[:page])
    end
  end
end
