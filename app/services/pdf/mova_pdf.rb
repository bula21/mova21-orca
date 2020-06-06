# frozen_string_literal: true

require 'prawn'

module Pdf
  class MovaPdf < BasePdf
    FONT_SIZE = 12
    def prepare_document(document)
      document.instance_exec do
        font_families.update('Mova' => {
                               normal: File.join(FONTS_PATH, 'mova/normal.ttf'),
                               #  italic: File.join(FONTS_PATH, 'arial/italic.ttf'),
                               #  bold_italic: File.join(FONTS_PATH, 'arial.ttf')
                               bold: File.join(FONTS_PATH, 'mova/bold.ttf')
                             })
        font 'Mova'
        font_size(FONT_SIZE)
      end
    end

    FULL_WIDTH = 455

    def document_options
      {
        page_size: 'A4',
        optimize_objects: true,
        compress: true,
        margin: [40, 70, 50, 70],
        align: :left, kerning: true
      }
    end

    renderable :logo do
      image_source = Rails.root.join('app/webpacker/images/mova-logo.png')
      width = 135
      image image_source, at: [bounds.right - width + 43, bounds.top + 16], width: width
    end
  end
end
