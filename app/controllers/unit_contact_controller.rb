# frozen_string_literal: true

class UnitContactController < ApplicationController
  def index
    authorize!(:contact, :unit)

    @unit = Unit.find(params[:unit_id])
  end
end
