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
        redirect_to admin_activity_categories_path, notice: 'Activity Category was successfully created.'
      else
        render :new
      end
    end

    def update
      if @activity_category.update(activity_category_params)
        redirect_to admin_activity_categories_path, notice: 'Activity Category was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @activity_category.destroy
      redirect_to admin_activity_categories_url, notice: 'Activity Category was successfully destroyed.'
    end

    private

    def activity_category_params
      params.require(:activity_category).permit(:label, :parent_id)
    end
  end
end
