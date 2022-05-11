class AddDistrictNumberToUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :units, :district_number, :integer

    reversible do |direction|
      direction.up do 
        Unit.all.find_each do |unit| 
          unit.update(district_number: unit.district.scan(/\d+/).last.to_i) if unit.district.present?
        end
      end
    end
  end
end
