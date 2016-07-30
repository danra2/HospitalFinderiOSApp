class AddColumnToHospitalsToInsurances < ActiveRecord::Migration
  def change
    add_column :hospitals_to_insurances, :hospital_id, :integer
    add_column :hospitals_to_insurances, :insurance_id, :integer
  end
end
