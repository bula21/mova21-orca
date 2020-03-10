# frozen_string_literal: true

require 'prawn'

module Pdf
  class InvoicePdf < BasePdf
    attr_reader :invoice

    def initialize(invoice)
      super()
      @invoice = invoice
    end

    def initialize_font
      super
      ocr_font_path = File.join(FONTS_PATH, 'ocrb', 'webfonts', 'OCR-B-regular-web.ttf')
      @document.font_families.update('ocr' => { normal: ocr_font_path })
    end

    def render
      render_recipient_address
      render_invoice_parts
      super
    end

    def render_invoice_text
      text
    end

    def render_recipient_address
      bounding_box [300, 690], width: 200, height: 140 do
        default_leading 4
        move_down 5
        text @invoice.unit.title, size: 9
        text @invoice.invoice_address, size: 11
      end
    end

    def render_invoice_parts
      move_down 20
      table invoice_parts_table_data,
            column_widths: [180, 200, 25, 89],
            cell_style: { borders: [], padding: [0, 4, 4, 0] } do
        cells.style(size: 10)
        column(2).style(align: :right)
        column(3).style(align: :right)
        row(-1).style(borders: [:top], font_style: :bold, padding: [4, 4, 4, 0])
      end
    end

    private

    def invoice_parts_table_data
      helpers = ActionController::Base.helpers
      data = @invoice.invoice_parts.map do |invoice_part|
        [invoice_part.label, invoice_part.breakdown, 'CHF', helpers.number_to_currency(invoice_part.amount, unit: '')]
      end
      data << ['Total', '', 'CHF', helpers.number_to_currency(@invoice.amount, unit: '')]
    end
  end
end
