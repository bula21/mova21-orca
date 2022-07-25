# frozen_string_literal: true

class ParticipantSearchesController < ApplicationController
  def show; end

  def create
    if params[:search].present? && params[:search].length > 3
      write_log_entry(current_user, params[:search])
      get_participants(params[:search])
    else
      @participants = ''
    end
    render :show
  end

  def get_participants(search)
    @participants = Participant.where('id = ? OR first_name ILIKE ? OR last_name ILIKE ? OR scout_name ILIKE ?',
                                      search.to_i, "%#{search}%",
                                      "%#{search}%", "%#{search}%").includes([:units, :participant_units])
  end

  def write_log_entry(user, text)
    @participant_search_log = ParticipantSearchLogs.new(searcher: user, search_query: text)
    @participant_search_log.save
  end
end
