# frozen_string_literal: true

class ActivityCategoryBlueprint < Blueprinter::Base
  identifier :id

  fields :code, :label_in_database, :parent_id
end
