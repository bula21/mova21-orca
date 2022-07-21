# frozen_string_literal: true

module Admin
  class CheckpointUnitsExportController < ApplicationController
    load_and_authorize_resource instance_name: :checkpoint_unit, class: CheckpointUnit

    def index
      authorize!(:export, CheckpointUnit)

      respond_to do |format|
        format.csv { send_exported_data(@checkpoint_units) }
      end
    end

    private

    def send_exported_data(checkpoint_units)
      exporter = CheckpointUnitsExporter.new(checkpoint_units)
      send_data exporter.export, filename: exporter.filename
    end
  end
end
