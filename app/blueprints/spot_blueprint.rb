# frozen_string_literal: true

class SpotBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :color

  association :fields, blueprint: FieldBlueprint
end
