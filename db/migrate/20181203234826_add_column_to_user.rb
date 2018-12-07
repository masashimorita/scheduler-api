class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :check_in_period, :integer, default: 1
    add_column :users, :break_hour, :integer, default: 1
  end
end
