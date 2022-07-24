# frozen_string_literal: true

class UnitActivitiesController < ApplicationController
  load_and_authorize_resource :unit
  load_and_authorize_resource through: :unit, except: %i[show commit stage_commit]
  before_action :check_phase

  def index
    @activities = Activity.accessible_by(current_ability)
    @activities = @activities.bookable_by(@unit).distinct unless params[:prefilter] == '0' && can?(:manage,
                                                                                                   UnitActivity)
    @activities = filter.apply(@activities).page params[:page]
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def create
    @unit_activity.priority_position = :last
    flash = if unit_activity_booking.phase?(:preview, :open) && @unit_activity.save
              { success: I18n.t('messages.created.success') }
            else
              { error: I18n.t('messages.created.error') }
            end
    redirect_to unit_unit_activities_path(@unit, anchor: helpers.anchor_for(@unit_activity.activity)), flash: flash
  end

  def stage_commit
    authorize!(:commit, @unit)
  end

  def commit
    authorize!(:commit, @unit)
    if unit_activity_booking.commit
      redirect_to unit_unit_activities_path(@unit)
    else
      render 'stage_commit'
    end
  end

  def destroy
    unit_activity_booking.phase?(:preview, :open) && @unit_activity.destroy
    redirect_to unit_unit_activities_path(@unit), notice: I18n.t('messages.deleted.success')
  end

  def priorize
    @unit_activity.update(priority_position: params[:index]) if unit_activity_booking.phase?(:preview, :open)
  end

  def update
    @unit_activity.assign_attributes(unit_activity_params)

    if unit_activity_booking.phase?(:preview, :open) && @unit_activity.save
      redirect_to unit_unit_activities_path(@unit, anchor: helpers.anchor_for(@unit_activity.activity)),
                  notice: I18n.t('messages.updated.success')
    else
      render :edit, alert: I18n.t('messages.updated.error')
    end
  end

  private

  def filter
    activity_filter_params = params[:activity_filter]&.permit(:min_participants_count, :stufe_recommended, :text,
                                                              :activity_category, tags: [], languages: [])
    session[:activity_filter_params] = activity_filter_params if params.key?(:activity_filter)
    @filter ||= ActivityFilter.new(session[:activity_filter_params] ||
                                     { number_of_units: current_user.present? ? 0 : 1 })
  end

  def check_phase
    raise CanCan::AccessDenied unless unit_activity_booking.phase?(:preview, :open, :committed)
  end

  def unit_activity_booking
    @unit_activity_booking ||= UnitActivityBooking.new(@unit)
  end

  def unit_activity_params
    params[:unit_activity].permit(:activity_id, :priority_postion)
  end
end
