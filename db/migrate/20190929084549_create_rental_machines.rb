class CreateRentalMachines < ActiveRecord::Migration[5.0]
  def change
    create_table :rental_machines do |t|
      t.string :code
      t.references :machine, foreign_key: true
      t.references :branch, foreign_key: true
      t.references :storage, foreign_key: true
      t.integer :status,default: 0, null: false, limit: 1
      t.string :remarks

      t.timestamps
      
      
    end
  end
end
