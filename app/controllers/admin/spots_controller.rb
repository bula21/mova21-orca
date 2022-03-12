# frozen_string_literal: true

module Admin
  class SpotsController < ApplicationController
    load_and_authorize_resource

    # GET /spots
    def index
      @spots = Spot.all.order(Arel.sql("LOWER(spots.name->>'de')"))
    end

    # GET /spots/1
    def show; end

    # GET /spots/new
    def new
      @spot = Spot.new
    end

    # GET /spots/1/edit
    def edit; end

    # POST /spots
    def create
      @spot = Spot.new(spot_params)

      if @spot.save
        redirect_to admin_spots_path, notice: t('messages.created.success')
      else
        render :new
      end
    end

    # PATCH/PUT /spots/1
    def update
      if @spot.update(spot_params)
        redirect_to admin_spots_path, notice: t('messages.updated.success')
      else
        render :edit
      end
    end

    # DELETE /spots/1
    def destroy
      @spot.destroy
      redirect_to admin_spots_path, notice: t('messages.deleted.success')
    end

    private

    def spot_params
      params.require(:spot).permit(:color, *I18n.available_locales.map { |l| :"name_#{l}" })
    end
  end
end
