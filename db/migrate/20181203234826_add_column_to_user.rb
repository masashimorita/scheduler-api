class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :check_in_period, :integer
  end
end
