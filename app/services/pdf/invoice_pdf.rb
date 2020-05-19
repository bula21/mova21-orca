# frozen_string_literal: true

require 'prawn'

module Pdf
  class InvoicePdf < MovaPdf
    attr_reader :invoice
    include ActionView::Helpers::NumberHelper

    def initialize(invoice)
      super()
      @invoice = invoice
    end

    def i18n_scope
      [:invoices, @invoice.category]
    end

    def title
      I18n.t(:title, scope: i18n_scope, ref: @invoice.ref)
    end

    def subtitle
      I18n.t(:subtitle, scope: i18n_scope, ref: @invoice.ref)
    end

    def prepare_document(document)
      super
      ocr_font_path = File.join(FONTS_PATH, 'ocrb', 'webfonts', 'OCR-B-regular-web.ttf')
      document.font_families.update('ocr' => { normal: ocr_font_path })
    end

    renderable :recipient_address do
      bounding_box [320, 622], width: 140, height: 90 do
        text @invoice.unit.abteilung
        @invoice.invoice_address&.lines { |line| text(line) }
      end
    end

    renderable :issued_at do
      next if @invoice.issued_at.blank?

      text I18n.t('issued_at', scope: i18n_scope, issued_at: I18n.l(@invoice.issued_at))
      move_down font_size
    end

    renderable :pre_text do
      interpolation_data = {
        salutation_name: @invoice.unit.lagerleiter&.salutation_name,
        camp_unit_title: @invoice.unit.title
      }
      I18n.t('pre_text', interpolation_data.merge(scope: i18n_scope)).lines.each { |line| text(line) }
    end

    renderable :invoice_parts do
      move_down 20
      table invoice_parts_table_data,
            column_widths: [169, 169, 116],
            cell_style: { borders: %i[left right top bottom], padding: [2, 4, 4, 2] } do
        column(2).style(align: :right)
        column(3).style(align: :right)
        row(-1).style(borders: %i[left right top bottom], font_style: :bold, padding: [4, 4, 4, 0])
      end
      move_down 20
    end

    renderable :post_text do
      I18n.t('post_text', scope: i18n_scope).lines.each { |line| text(line) }
    end

    renderable :payment_info do
      height = 140
      bounding_box([0, bounds.bottom + height], width: FULL_WIDTH, height: height) do
        table(payment_info_table_data,
              column_widths: [150, 120, 185],
              cell_style: { borders: [], padding: [4, 4, 4, 4] }) { column(1).style(size: 10) }
      end
    end

    renderable :code_line do
      code_line = esr_service.code_line(ref: invoice.ref, amount: invoice.amount)
      width = 395
      bounding_box([bounds.right - width, bounds.bottom], width: width, height: 11) do
        font('ocr', size: 10.5) do
          text code_line, align: :right, character_spacing: 0.5
        end
      end
    end

    private

    def invoice_parts_table_data
      data = @invoice.invoice_parts.map do |invoice_part|
        [invoice_part.label, invoice_part.breakdown, number_to_currency(invoice_part.amount, unit: 'CHF')]
      end
      data << ['', '', number_to_currency(@invoice.amount, unit: 'CHF')]
    end

    def payment_info_table_data
      I18n.with_options scope: %i[invoices payment_info] do |i18n|
        [
          [{ content: i18n.t('recipient_address'), rowspan: 4 },
           i18n.t('recipient_name_label'), i18n.t('recipient_name')],
          [i18n.t('recipient_account_label'), i18n.t('recipient_account')],
          [i18n.t('ref_label'), esr_service.format_ref(@invoice.ref)],
          [i18n.t('amount_label'), number_to_currency(@invoice.amount, unit: 'CHF')]
        ]
      end
    end

    def esr_service
      @esr_service ||= EsrService.new
    end
  end
end
