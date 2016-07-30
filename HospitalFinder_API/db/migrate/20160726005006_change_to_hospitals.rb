class ChangeToHospitals < ActiveRecord::Migration
  def change
    rename_column :hospitals, :consultingFeeRange, :consultingFee
    change_column :hospitals, :ratingPoints, :float
    rename_column :hospitals, :ratingPoints, :rating
  end
end
