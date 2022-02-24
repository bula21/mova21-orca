# frozen_string_literal: true

class UnitVisitorDaysController < ApplicationController
  load_and_authorize_resource :unit
  load_and_authorize_resource :unit_visitor_day, through: :unit, singleton: true

  def show
    redirect_to edit_unit_unit_visitor_day_path(@unit)
  end

  def edit; end

  def create
    if @unit_visitor_day.update(unit_visitor_day_params)
      redirect_to edit_unit_unit_visitor_day_path(@unit),
                  notice: I18n.t('messages.updated.success')
    else
      render :edit, alert: I18n.t('messages.updated.error')
    end
  end

  def destroy
    redirect_to edit_unit_unit_visitor_day_path(@unit), notice: I18n.t('messages.deleted.success')
  end

  def update
    @unit_visitor_day.assign_attributes(unit_visitor_day_params)
    @unit_visitor_day.phase = :committed if params[:commit] == '1'

    if @unit_visitor_day.save
      redirect_to edit_unit_unit_visitor_day_path(@unit),
                  notice: I18n.t('messages.updated.success')
    else
      render :edit, alert: I18n.t('messages.updated.error')
    end
  end

  private

  def unit_visitor_day_params
    permitted = %i[responsible_firstname responsible_lastname responsible_address responsible_postal_code
                   responsible_place responsible_salutation responsible_email responsible_phone]
    if @unit_visitor_day.phase_open?
      permitted << %i[u6_tickets u16_tickets u16_ga_tickets
                      ga_tickets other_tickets]
    end
    permitted << %i[phase] if can?(:manage, UnitVisitorDay)

    params[:unit_visitor_day].permit(*permitted)
  end
end
