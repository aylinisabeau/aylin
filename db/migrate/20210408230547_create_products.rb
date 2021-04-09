class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.integer :active_status, default: 1, null: false
      t.decimal :price, precision: 16, scale: 4

      t.timestamps
    end
  end
end
