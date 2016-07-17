class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :body, null: false
      t.text :title, null: false
      t.belongs_to :user, foreign_key: true, null: false
      t.index :title, unique: true
      t.timestamps
    end
  end
end
