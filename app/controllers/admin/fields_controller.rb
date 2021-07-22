# frozen_string_literal: true

module Admin
  class FieldsController < ApplicationController
    load_and_authorize_resource :spot
    load_and_authorize_resource through: :spot

    # GET /fields
    def index
      @fields = @spot.fields
    end

    # GET /fields/1
    def show; end

    # GET /fields/new
    def new
      @field = @spot.fields.new
    end

    # GET /fields/1/edit
    def edit; end

    # POST /fields
    def create
      @field = @spot.fields.new(field_params)

      if @field.save
        redirect_to admin_spot_fields_path(@spot), notice: t('messages.created.success')
      else
        render :new
      end
    end

    # PATCH/PUT /fields/1
    def update
      if @field.update(field_params)
        redirect_to admin_spot_fields_path(@spot), notice: t('messages.updated.success')
      else
        render :edit
      end
    end

    # DELETE /fields/1
    def destroy
      @field.destroy
      redirect_to admin_fields_path, notice: t('messages.deleted.success')
    end

    private

    # Only allow a trusted parameter "white list" through.
    def field_params
      params.require(:field).permit(:name)
    end
  end
end
