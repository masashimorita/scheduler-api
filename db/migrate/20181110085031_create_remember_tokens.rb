class CreateRememberTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :remember_tokens do |t|
      t.string :code
      t.string :email
      t.references :user, foreign_key: true
      t.timestamps :expired_at

      t.timestamps
    end
  end
end
