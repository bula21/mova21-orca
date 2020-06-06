# frozen_string_literal: true

require 'prawn'

module Pdf
  class BasePdf
    FONTS_PATH = Rails.root.join('app/webpacker/fonts/')
    include Prawn::View

    def initialize(document = Prawn::Document.new(document_options))
      @document = document
    end

    def self.renderable(name, renderable = nil, &block)
      renderables[name] = renderable || block
    end

    def self.renderables
      @renderables ||= superclass.ancestors.include?(BasePdf) && superclass.renderables || {}
    end

    def render_onto(document, only: self.class.renderables.keys)
      prepare_document(document)
      only.each do |renderable_key|
        renderable = self.class.renderables[renderable_key]
        renderable.is_a?(BasePdf) ? renderable.render_onto(document) : instance_exec(&renderable)
      end
    end

    def render
      render_onto(@document)
      @document.render
    end

    def prepare_document(document); end
  end
end
