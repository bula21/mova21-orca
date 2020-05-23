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

    def title; end

    def subtitle
      I18n.t(:subtitle, scope: i18n_scope, ref: @invoice.ref)
    end

    def prepare_document(document)
      super
      ocr_font_path = File.join(FONTS_PATH, 'ocrb', 'webfonts', 'OCR-B-regular-web.ttf')
      document.font_families.update('ocr' => { normal: ocr_font_path })
    end

    renderable :issuer_address do
      bounding_box [bounds.left, bounds.top], width: 200, height: 115 do
        I18n.t('issuer_address', scope: %i[invoices payment_info]).lines.each { |line| text(line) }
      end
      stroke { horizontal_rule }
    end

    renderable :recipient_address do
      bounding_box [320, 622], width: 140, height: 110 do
        text @invoice.unit.abteilung
        @invoice.invoice_address&.lines { |line| text(line) }
      end
    end

    renderable :header do
      text I18n.t('issued_at', scope: i18n_scope, issued_at: I18n.l(@invoice.issued_at)) if @invoice.issued_at

      move_down FONT_SIZE
      text I18n.t(:ref, scope: i18n_scope, ref: @invoice.ref)

      move_down FONT_SIZE
      text I18n.t(:title, scope: i18n_scope, ref: @invoice.ref), style: :bold

      move_down (FONT_SIZE * 2)
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
            cell_style: { borders: %i[left right top bottom], border_width: 0.5,
                          border_color: 'bbbbbb', padding: [2, 4, 2, 4] } do
        column(2).style(align: :right)
        column(3).style(align: :right)
        row(-1).style(border_bottom_color: '000000', font_style: :bold)
      end
    end

    renderable :post_text do
      move_down 20
      I18n.t('post_text', scope: i18n_scope).lines.each { |line| text(line) }
    end

    renderable :payment_info do
      height = 90
      bounding_box([0, bounds.bottom + height], width: FULL_WIDTH, height: height) do
        table(payment_info_table_data,
              column_widths: [180, 275],
              cell_style: { borders: [], padding: [2, 2, 2, 2] })
      end
    end

    renderable :code_line do
      code_line = esr_service.code_line(ref: invoice.ref, amount: invoice.amount)
      width = 395
      bounding_box([bounds.right - width + 50, bounds.bottom - 8], width: width, height: 11) do
        font('ocr', size: 10.5) do
          text code_line, align: :right, character_spacing: 0.5
        end
      end
    end

    private

    def invoice_parts_table_data
      total = number_to_currency(@invoice.amount, unit: 'CHF')
      data = @invoice.invoice_parts.map do |invoice_part|
        [invoice_part.label, invoice_part.breakdown, number_to_currency(invoice_part.amount, unit: 'CHF')]
      end
      data << [I18n.t('total_label', scope: %i[invoices payment_info]), '', total]
    end

    def payment_info_table_data
      I18n.with_options scope: %i[invoices payment_info] do |i18n|
        [
          [i18n.t('issuer_name_label'), i18n.t('issuer_name')],
          [i18n.t('issuer_account_label'), i18n.t('issuer_account')],
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
