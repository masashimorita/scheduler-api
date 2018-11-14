class CreateMonthlyReports < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_reports do |t|
      t.text :data
      t.float :total_hour
      t.integer :total_days
      t.float :average_hour
      t.integer :period_month
      t.integer :period_year
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
