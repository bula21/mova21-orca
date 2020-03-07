# frozen_string_literal: true

require 'prawn'

module Pdf
  class BasePdf
    FONTS_PATH = Rails.root.join('app/webpacker/fonts/')
    include Prawn::View

    def initialize
      @document = Prawn::Document.new(document_options)
      initialize_font
    end

    def initialize_font
      @document.font_families.update('OpenSans' => {
                                       normal: File.join(FONTS_PATH, 'OpenSans-Regular.ttf'),
                                       italic: File.join(FONTS_PATH, 'OpenSans-Italic.ttf'),
                                       bold: File.join(FONTS_PATH, 'OpenSans-Bold.ttf'),
                                       bold_italic: File.join(FONTS_PATH, 'OpenSans-BoldItalic.ttf')
                                     })
      @document.font 'OpenSans'
      @document.font_size(10)
    end

    def document_options
      {
        page_size: 'A4',
        optimize_objects: true,
        compress: true,
        margin: [50] * 4,
        align: :left, kerning: true
      }
    end
  end
end
