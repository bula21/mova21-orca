# frozen_string_literal: true

class EsrService
  def generate(invoice)
    append_checksum format('%<unit_id>05d%<invoice_id>06d', unit_id: invoice.unit_id,
                                                            invoice_id: invoice.id + 100_000)
  end

  def checksum(ref)
    check_table = [0, 9, 4, 6, 8, 2, 7, 1, 3, 5]
    (10 - ref.to_s.scan(/\d/).inject(0) { |carry, digit| check_table[(digit.to_i + carry) % check_table.size] }) % 10
  end

  def append_checksum(ref)
    ref.to_s + checksum(ref).to_s
  end

  def format_ref(ref)
    return '' if ref.blank?

    ref.reverse.chars.in_groups_of(5).reverse.map { |group| group.reverse.join }.join(' ')
  end

  def code_line(esr_participant_nr: 'XXX-XXXXX-X', ref:, amount:, esr_mode: '01')
    code = {
      esr_mode: esr_mode,
      amount_in_cents: amount * 100,
      checksum_1: checksum(esr_mode.to_s + format('%<amount>010d', amount: amount * 100)),
      ref: ref.to_s.rjust(26, '0'),
      account_code: esr_participant_nr
    }
    format('%<esr_mode>s%<amount_in_cents>010d%<checksum_1>d>%<ref>s+ %<account_code>s>', code)
  end
end
