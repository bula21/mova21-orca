# frozen_string_literal: true

module ApplicationHelper
  require 'redcarpet'

  def language_change_url_for(locale)
    url_for(safe_query_parameters.merge('locale' => locale))
  end

  def markdown(content)
    return '' if content.blank?

    markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                         autolink: true,
                                         tables: true)
    markdown.render(content)
  end

  def anchor_for(model)
    "#{model.model_name.param_key}-#{model.to_param}"
  end

  private

  def safe_query_parameters
    params.except(:host, :port, :protocol, :domain, :subdomain).permit!
  end
end
