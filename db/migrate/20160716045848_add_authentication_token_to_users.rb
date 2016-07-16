class AddAuthenticationTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authentication_token, :string, null: false
    add_column :users, :authentication_token_expires_at, :datetime, null: false
    add_index :users, :authentication_token, unique: true
  end
end
