# frozen_string_literal: true

module Admin
  class ActivityCategoriesController < ApplicationController
    load_and_authorize_resource

    def index; end

    def new
      @activity_category = ActivityCategory.new
    end

    def edit; end

    def create
      @activity_category = ActivityCategory.new(activity_category_params)

      if @activity_category.save
        redirect_to admin_activity_categories_path, notice: I18n.t('messages.created.success')
      else
        render :new
      end
    end

    def update
      if @activity_category.update(activity_category_params)
        redirect_to admin_activity_categories_path, notice: I18n.t('messages.updated.success')
      else
        render :edit
      end
    end

    def destroy
      @activity_category.destroy
      redirect_to admin_activity_categories_url, notice: I18n.t('messages.deleted.success')
    end

    private

    def activity_category_params
      params.require(:activity_category).permit(:parent_id, :code, I18n.available_locales.map { |l| :"label_#{l}" })
    end
  end
end
