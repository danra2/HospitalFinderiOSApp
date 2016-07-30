class AddColumnsToHospital < ActiveRecord::Migration
  def change
    add_column :hospitals, :website, :string
    add_column :hospitals, :phone, :string
    add_column :hospitals, :startTime, :time
    add_column :hospitals, :endTime, :time
    add_column :hospitals, :description, :text
  end
end
