# frozen_string_literal: true

module Admin
  class StufenController < ApplicationController
    load_and_authorize_resource

    def index; end

    def new
      @stufe = Stufe.new
    end

    def edit; end

    def create
      @stufe = Stufe.new(stufen_params)

      if @stufe.save
        redirect_to admin_stufen_path, notice: I18n.t('messages.created.success')
      else
        render :new
      end
    end

    def update
      if @stufe.update(stufen_params)
        redirect_to admin_stufen_path, notice: I18n.t('messages.updated.success')
      else
        render :edit
      end
    end

    def destroy
      @stufe.destroy
      redirect_to admin_stufen_url, notice: I18n.t('messages.deleted.success')
    end

    private

    def stufen_params
      params.require(:stufe).permit(:code, I18n.available_locales.map { |l| :"name_#{l}" })
    end
  end
end
