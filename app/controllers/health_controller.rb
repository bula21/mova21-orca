class HealthController < ApplicationController
  skip_before_action :authenticate_user!, only: [:check]

  def check
    val = ActiveRecord::Base.connection.execute('select 1+2 as val').first['val']
    render plain: "1+2=#{val}"
  end
end
