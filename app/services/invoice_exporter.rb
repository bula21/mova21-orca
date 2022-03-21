# frozen_string_literal: true

class InvoiceExporter
  HEADERS = [
    'Kdnr', 'Name1', 'Name2', 'Strasse', 'Plz', 'Ort',
    'RG-Nummer', 'Inkl. MWST', 'exkl. MWST', 'ESR-Ref.Nr.'
  ].freeze

  def initialize(invoices = Invoice.all)
    @invoices = invoices
  end

  def export(options = {})
    CSV.generate(**csv_options.merge(options)) do |csv|
      csv << HEADERS
      @invoices.each { |invoice| csv << invoice_attributes(invoice) }
    end
  end

  def csv_options
    {
      headers: true, force_quotes: true
    }
  end

  def invoice_attributes(invoice)
    invoice.instance_eval do
      lagerleiter = unit.lagerleiter
      [
        unit.id, unit.title,
        lagerleiter.full_name, lagerleiter.address, lagerleiter.zip_code, lagerleiter.town,
        id, amount, amount, ref
      ]
    end
  end
end
