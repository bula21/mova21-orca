# frozen_string_literal: true

class UnitVisitorDay < ApplicationRecord
  belongs_to :unit, inverse_of: :unit_visitor_day

  enum phase: { closed: 0, open: 1, committed: 2 }, _prefix: true

  validates :u6_tickets, :u16_tickets, :u16_ga_tickets, :ga_tickets, :other_tickets,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :responsible_email, format: { with: Devise.email_regexp }, allow_blank: true
  validates :responsible_firstname, :responsible_lastname, :responsible_address, :responsible_email,
            :responsible_phone, :responsible_salutation, :responsible_postal_code, :responsible_place, :ltb_accepted,
            presence: true, unless: -> { ticket_count.zero? }
  validate do
    next if ticket_count.zero?

    errors.add(:base, :not_enough_tickets_left) if tickets_free < (ticket_count - tickets_was.values.sum)
  end

  def tickets
    {
      u6_tickets: u6_tickets,
      u16_tickets: u16_tickets,
      u16_ga_tickets: u16_ga_tickets,
      ga_tickets: ga_tickets,
      other_tickets: other_tickets
    }
  end

  def tickets_was
    {
      u6_tickets: u6_tickets_was || 0,
      u16_tickets: u16_tickets_was || 0,
      u16_ga_tickets: u16_ga_tickets_was || 0,
      ga_tickets: ga_tickets_was || 0,
      other_tickets: other_tickets_was || 0
    }
  end

  def at
    unit_activity_execution&.activity_execution&.starts_at&.to_date
  end

  def unit_activity_execution
    @unit_activity_execution ||= unit.unit_activity_executions.joins(:activity_execution)
                                     .find_by(activity_executions: {
                                                activity_id: ENV.fetch('VISITOR_DAY_ACTIVITY_ID', 223)
                                              })
  end

  def activity_execution
    unit_activity_execution&.activity_execution
  end

  def ticket_count
    tickets.values.compact.sum
  end

  def tickets_sold
    return -1 if activity_execution.blank?

    activity_execution.unit_activity_executions.filter_map do |unit_activity_execution|
      unit_activity_execution.unit.unit_visitor_day&.ticket_count
    end.sum
  end

  def tickets_free
    return -1 if activity_execution.blank?

    tickets_total = activity_execution.amount_participants
    tickets_total - tickets_sold
  end
end
