# frozen_string_literal: true

class ParticipantSearchesController < ApplicationController
  before_action :authorize_search

  def show; end

  def create
    @participants = search_participants

    render :show
  end

  private

  def authorize_search
    authorize!(:search, Participant)
  end

  def search_participants
    return Participant.none if params[:search].blank? || params[:search].length < 3

    search_text = params[:search]

    write_log_entry(search_text)
    Participant.where('id = ? OR first_name ILIKE ? OR last_name ILIKE ? OR scout_name ILIKE ?',
                      search_text.to_i, "%#{search_text}%",
                      "%#{search_text}%", "%#{search_text}%").includes(%i[units participant_units])
  end

  def write_log_entry(search_text)
    @participant_search_log = ParticipantSearchLog.new(searcher: current_user, search_query: search_text)
    @participant_search_log.save
  end
end
