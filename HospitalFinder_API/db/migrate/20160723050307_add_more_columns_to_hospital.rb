class AddMoreColumnsToHospital < ActiveRecord::Migration
  def change
    add_column :hospitals, :location, :string
    add_column :hospitals, :latitude, :float
    add_column :hospitals, :longitude, :float
    add_column :hospitals, :consultingFeeRange, :integer
    add_column :hospitals, :ratingPoints, :integer
    add_column :hospitals, :numberOfRatings, :integer
  end
end
