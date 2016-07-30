class CreateHospitalsToInsurances < ActiveRecord::Migration
  def change
    create_table :hospitals_to_insurances do |t|

      t.timestamps null: false
    end
  end
end
