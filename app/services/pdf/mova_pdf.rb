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
        margin: [50, 70, 50, 70],
        align: :left, kerning: true
      }
    end

    renderable :logo do
      image_source = Rails.root.join('app/webpacker/images/mova-logo.png')
      width = 135
      image image_source, at: [bounds.right - width, bounds.top], width: width
    end

    renderable :header do 
      bounding_box [bounds.left, bounds.top - 44], width: FULL_WIDTH, height: 55 do
        text title, size: 16, style: :bold
        move_down FONT_SIZE
        text subtitle, size: 14
        move_down FONT_SIZE
        stroke { horizontal_rule }
      end
    end
  end
end
