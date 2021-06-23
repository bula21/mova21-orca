class MergeRootCampUnitWithStufe < ActiveRecord::Migration[6.0]
  def change
    add_column :stufen, :root_camp_unit_id, :integer, null: true
    add_reference :units, :stufe, foreign_key: true

    reversible do |direction|
      direction.up do 
        Unit.find_each do |unit|
          unit.update(stufe: Stufe.find_by(code: unit[:stufe]))
        end
      end
    end
  end
end
