require 'prawn'

module Pdf
  class InvoicePdf < BasePdf
    attr_reader :invoice
    delegate :booking, :organisation, to: :invoice

    def initialize(invoice)
      super()
      @invoice = invoice
    end

    def initialize_font
      super
      ocr_font_path = File.join(FONTS_PATH, 'ocrb', 'webfonts', 'OCR-B-regular-web.ttf')
      @document.font_families.update('ocr' => { normal: ocr_font_path })
    end
  end

  def render
    render_recipient_address
    text "Hello"
    super
  end

  def render_recipient_address
    bounding_box [300, 690], width: 200, height: 140 do
      default_leading 4
      text Unit.model_name.human(count: :one), size: 13, style: :bold
      move_down 5
      text @invoice.unit.name, size: 9
      text @invoice.invoice_address, size: 11
    end
  end
end
