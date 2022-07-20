# frozen_string_literal: true

module Admin
  class CheckpointsController < ApplicationController
    load_and_authorize_resource :checkpoint

    def index; end

    def edit; end

    def update
      if @checkpoint.update(checkpoint_params)
        redirect_to admin_checkpoints_path, notice: t('messages.updated.success')
      else
        render :edit
      end
    end

    private

    def checkpoint_params
      params.require(:checkpoint).permit(
        *I18n.available_locales.map { |l| :"title_#{l}" },
        *I18n.available_locales.map { |l| :"description_check_in_#{l}" },
        *I18n.available_locales.map { |l| :"description_check_out_#{l}" }
      )
    end
  end
end
