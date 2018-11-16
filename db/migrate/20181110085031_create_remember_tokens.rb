class CreateRememberTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :remember_tokens do |t|
      t.string :code, null: false
      t.string :email, null: false
      t.references :user, foreign_key: true, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end
  end
end
