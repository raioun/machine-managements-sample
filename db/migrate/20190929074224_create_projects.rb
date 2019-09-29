class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.references :customer, foreign_key: true
      t.string :name
      t.string :address
      t.integer :status,default: 0, null: false, limit: 1

      t.timestamps
    end
  end
end
