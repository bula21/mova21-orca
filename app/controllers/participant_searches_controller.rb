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

    search_query = search_text.split.map do |term|
      "(id = #{term.to_i} " \
        "or first_name ILIKE '%#{term}%' " \
        "or last_name ILIKE '%#{term}%' " \
        "or scout_name ILIKE '%#{term}%')"
    end.join(' OR ')

    Participant.where(search_query).includes(%i[units participant_units])
  end

  def write_log_entry(search_text)
    @participant_search_log = ParticipantSearchLog.new(searcher: current_user, search_query: search_text)
    @participant_search_log.save
  end
end
