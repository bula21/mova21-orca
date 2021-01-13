# frozen_string_literal: true

module Admin
  class TagsController < ApplicationController
    load_and_authorize_resource

    def index; end

    def new
      @tag = Tag.new
    end

    def edit; end

    def create
      @tag = Tag.new(tag_params)

      if @tag.save
        redirect_to admin_tags_path, notice: 'Tag was successfully created.'
      else
        render :new
      end
    end

    def update
      if @tag.update(tag_params)
        redirect_to admin_tags_path, notice: 'Tag was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @tag.destroy
      redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.'
    end

    private

    def tag_params
      params.require(:tag).permit(:code, :label, :icon)
    end
  end
end