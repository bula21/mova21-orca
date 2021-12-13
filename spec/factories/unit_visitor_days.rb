# frozen_string_literal: true

FactoryBot.define do
  factory :unit_visitor_day do
    unit
    u6_tickets { 0 }
    u16_tickets { 0 }
    u16_ga_tickets { 0 }
    ga_tickets { 0 }
    other_tickets { 0 }
    responsible_contact { 'Peter Muster' }
    responsible_email { 'peter@muster.com' }
    responsible_phone { '0123122' }
    phase { :open }
  end
end
