class CreateReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.references :thermostat, foreign_key: true
      t.integer :tracking_number, index: true
      t.float :temperature
      t.float :humidity
      t.float :battery_charge
      t.timestamps
    end
  end
end
