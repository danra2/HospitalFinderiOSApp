class ChangesToModels < ActiveRecord::Migration
  def change
    drop_table :insurances
  end
end
