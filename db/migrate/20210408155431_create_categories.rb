class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :active_status, default: 1, null: false
      t.text :description

      t.timestamps
    end
  end
end
