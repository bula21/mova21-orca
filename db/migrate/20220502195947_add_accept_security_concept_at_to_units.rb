class AddAcceptSecurityConceptAtToUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :units, :accept_security_concept_at, :datetime, null: true
  end
end
