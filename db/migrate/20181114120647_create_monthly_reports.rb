class CreateMonthlyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_reports do |t|
      t.text :data, null: false
      t.float :total_hour, null: false
      t.integer :total_days, null: false
      t.float :average_hour, null: false
      t.integer :period_month, null: false
      t.integer :period_year, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
