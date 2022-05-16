# frozen_string_literal: true

module Admin
  class FixedEventsController < ApplicationController
    load_and_authorize_resource

    def index
      respond_to do |format|
        format.json do
          stufe = Stufe.find_by(code: params[:stufe])
          fixed_events = stufe.blank? ? FixedEvent.all : stufe.fixed_events
          render json: FixedEventBlueprint.render(fixed_events)
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
      attach_attachments

      if @fixed_event.save
        redirect_to admin_fixed_events_path, notice: I18n.t('messages.created.success')
      else
        render :new
      end
    end

    def update
      attach_attachments
      if @fixed_event.update(fixed_event_params)
        redirect_to edit_admin_fixed_event_path(@fixed_event), notice: I18n.t('messages.updated.success')
      else
        render :edit
      end
    end

    def destroy
      @fixed_event.destroy
      redirect_to admin_fixed_events_path, notice: I18n.t('messages.deleted.success')
    end

    def delete_attachment
      type = params[:type]&.to_sym
      if FixedEvent::ATTACHMENTS.include?(type)
        attachment = @fixed_event.public_send(type)
        attachment = attachment.find_by(id: params[:attachment_id]) if params[:attachment_id].present?
        attachment.purge if attachment.respond_to?(:purge)
      end
      redirect_to edit_admin_fixed_event_path(@fixed_event)
    end

    private

    def attach_attachments
      %i[language_documents_de language_documents_fr language_documents_it].each do |attachment|
        next if params[:fixed_event][attachment].blank?

        @fixed_event.public_send(attachment).attach(params[:fixed_event][attachment])
      end
    end

    def set_fixed_event
      @fixed_event = FixedEvent.find(params[:id])
    end

    def fixed_event_params
      params.require(:fixed_event).permit(:starts_at, :ends_at, I18n.available_locales.map do |l|
                                                                  :"title_#{l}"
                                                                end, stufe_ids: [])
    end
  end
end
