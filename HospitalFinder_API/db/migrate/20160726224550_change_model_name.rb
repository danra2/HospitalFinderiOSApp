class ChangeModelName < ActiveRecord::Migration
  def change
    rename_table :hospitals_to_insurances, :joins
  end
end
