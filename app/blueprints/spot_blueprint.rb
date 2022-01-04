# frozen_string_literal: true

class SpotBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :color

  view :with_fields do
    association :fields, blueprint: FieldBlueprint
  end
end
