class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: true
      t.integer :active_status, default: 1, null: false
      t.datetime :last_login
      t.string :password_digest

      t.timestamps
    end
  end
end
