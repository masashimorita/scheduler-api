class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.date :record_date, index: true
      t.float :worked_hour
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
