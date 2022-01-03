# frozen_string_literal: true

module Admin
  class FixedEventsController < ApplicationController
    load_and_authorize_resource

    def index
      respond_to do |format|
        format.json do
          render json: FixedEventBlueprint.render(FixedEvent.all)
        end
        format.html
      end
    end

    def new
      @fixed_event = FixedEvent.new
    end

    def edit; end

    def create
      @fixed_event = FixedEvent.new(fixed_event_params)

      if @fixed_event.save
        redirect_to admin_fixed_events_path, notice: I18n.t('messages.created.success')
      else
        render :new
      end
    end

    def update
      if @fixed_event.update(fixed_event_params)
        redirect_to admin_fixed_events_path, notice: I18n.t('messages.updated.success')
      else
        render :edit
      end
    end

    def destroy
      @fixed_event.destroy
      redirect_to admin_fixed_events_path, notice: I18n.t('messages.deleted.success')
    end

    private

    def set_fixed_event
      @fixed_event = FixedEvent.find(params[:id])
    end

    def fixed_event_params
      params.require(:fixed_event).permit(:starts_at, :ends_at, I18n.available_locales.map { |l| :"title_#{l}" })
    end
  end
end
