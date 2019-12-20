# frozen_string_literal: true

module ApplicationHelper
  def language_change_url_for(locale)
    url_for(safe_query_parameters.merge('locale' => locale))
  end

  private

  def safe_query_parameters
    params.except(:host, :port, :protocol, :domain, :subdomain).permit!
  end
end
