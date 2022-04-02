# frozen_string_literal: true

FactoryBot.define do
  factory :unit_visitor_day do
    unit
    u6_tickets { 0 }
    u16_tickets { 0 }
    u16_ga_tickets { 0 }
    ga_tickets { 0 }
    other_tickets { 0 }
    ltb_accepted { true }
    responsible_firstname { 'Peter' }
    responsible_lastname { 'Muster' }
    responsible_salutation { 'Herr' }
    responsible_place { 'Zürich' }
    responsible_postal_code { '8000' }
    responsible_address { 'Teststrasse 1' }
    responsible_email { 'peter@muster.com' }
    responsible_phone { '0123122' }
    phase { :open }
  end
end
