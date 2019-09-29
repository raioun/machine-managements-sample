class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :out_date
      t.string :out_time
      t.date :in_date
      t.string :in_time
      t.integer :status,default: 0, null: false, limit: 1
      t.references :project, foreign_key: true
      t.references :orderer, foreign_key: true
      t.references :rental_machine, foreign_key: true
      t.references :user, foreign_key: true
      t.string :remarks

      t.timestamps
    end
  end
end
