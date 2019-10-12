class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.date :out_date
      t.string :out_time
      t.date :in_date
      t.string :in_time
      t.integer :status,default: 0, null: false, limit: 1
      # t.references :project, foreign_key: true
      t.bigint :project_id
      # t.references :orderer, foreign_key: true
      t.bigint :orderer_id
      # t.references :rental_machine, foreign_key: true
      t.bigint :rental_machine_id
      # t.references :user, foreign_key: true
      t.bigint :user_id
      t.string :remarks

      t.timestamps
    end
  end
end
