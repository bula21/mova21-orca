# frozen_string_literal: true

class UnitVisitorDay < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_visitor_day

  enum phase: { closed: 0, open: 1, committed: 2 }, _prefix: true

  validates :u6_tickets, :u16_tickets, :u16_ga_tickets, :ga_tickets, :other_tickets,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :responsible_email, format: { with: Devise.email_regexp }, allow_nil: true
  validates :responsible_contact, :responsible_email, :responsible_phone,
            presence: true, unless: -> { tickets.values.all?(&:zero?) }

  def tickets
    {
      u6_tickets: u6_tickets,
      u16_tickets: u16_tickets,
      u16_ga_tickets: u16_ga_tickets,
      ga_tickets: ga_tickets,
      other_tickets: other_tickets
    }
  end

  def at
    Time.zone.today
  end
end
