# frozen_string_literal: true

class UnitCommunicationsController < ApplicationController
  def index
    head :unauthorized unless current_user.role_unit_communication?

    return unless params[:unit_filter]

    unit_params = params[:unit_filter][:unit_ids]
    @unit_ids = unit_params.split(',')
    return unless @unit_ids

    @units = Unit.where(id: @unit_ids)
    @emails = @units.map { |u| u.lagerleiter.email }.join(',')
  end
end
