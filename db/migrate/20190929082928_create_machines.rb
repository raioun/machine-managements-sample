class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name
      t.string :type1
      t.string :type2

      t.timestamps
    end
  end
end
