class CreateStorages < ActiveRecord::Migration[5.2]
  def change
    create_table :storages do |t|
      t.string :name
      t.string :address
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
