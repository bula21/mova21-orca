# frozen_string_literal: true

module Admin
  class TransportLocationsController < ApplicationController
    load_and_authorize_resource

    def index; end

    def new
      @transport_location = TransportLocation.new
    end

    def edit; end

    def create
      @transport_location = TransportLocation.new(transport_location_params)

      if @transport_location.save
        redirect_to admin_transport_locations_path, notice: 'Transport location was successfully created.'
      else
        render :new
      end
    end

    def update
      if @transport_location.update(transport_location_params)
        redirect_to admin_transport_locations_path, notice: 'Transport location was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @transport_location.destroy
      redirect_to admin_transport_locations_url, notice: 'Transport location was successfully destroyed.'
    end

    private

    def transport_location_params
      params.require(:transport_location).permit(:name, :max_participants)
    end
  end
end
