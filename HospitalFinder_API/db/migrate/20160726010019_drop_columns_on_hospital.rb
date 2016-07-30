class DropColumnsOnHospital < ActiveRecord::Migration
  def change
    remove_column :hospitals, :numberOfRatings
    add_column :hospitals, :city, :string
  end
end
