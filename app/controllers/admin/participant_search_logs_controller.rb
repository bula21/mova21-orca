# frozen_string_literal: true

module Admin
  class ParticipantSearchLogsController < ApplicationController
    def show
      authorize!(:manage, :all)
      @logs = ParticipantSearchLog.all.order(created_at: :desc).includes([:searcher]).page params[:page]
    end
  end
end
