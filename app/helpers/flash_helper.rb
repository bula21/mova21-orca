# frozen_string_literal: true

module FlashHelper
  def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      notice: 'alert-info',
      alert: 'alert-warning'
    }.fetch(flash_type.to_sym, flash_type.to_s)
  end
end
