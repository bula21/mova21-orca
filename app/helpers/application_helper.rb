# frozen_string_literal: true

module ApplicationHelper
  require 'redcarpet'

  def language_change_url_for(locale)
    url_for(safe_query_parameters.merge('locale' => locale))
  end

  def markdown(content)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                          autolink: true,
                                          tables: true)
    @markdown.render(content)
  end

  private

  def safe_query_parameters
    params.except(:host, :port, :protocol, :domain, :subdomain).permit!
  end
end
