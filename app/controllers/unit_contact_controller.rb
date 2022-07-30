# frozen_string_literal: true

class UnitContactController < ApplicationController
  def index
    authorize!(:contact, :unit)

    @unit = Unit.find(params[:unit_id])
    @contact_units = @unit.contact_phonenumber_1.to_s + ", " + @unit.contact_phonenumber_2.to_s
  end
end
