# frozen_string_literal: true

class DeleteActivityExecutionsController < ApplicationController
  load_and_authorize_resource :activity

  def index; end

  def destroy
    deletions = @activity.activity_executions.where('starts_at::date IN (?)',
                                                    delete_activity_executions_params[:days].filter(&:present?))
                         .destroy_all
    if deletions
      redirect_to activity_delete_activity_executions_path(@activity),
                  flash: { success: t('delete_activity_executions.destroy.success', count: deletions.count) }
    else
      flash[:error] = t('messages.deleted.error')
      render :index
    end
  end

  def delete_activity_executions_params
    params.require(:delete_executions).permit(days: [])
  end
end
