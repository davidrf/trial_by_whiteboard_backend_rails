class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.string :password_digest, null: false
      t.timestamps
      t.index :email, unique: true
      t.index :username, unique: true
    end
  end
end
