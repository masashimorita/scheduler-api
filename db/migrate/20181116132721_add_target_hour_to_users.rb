class AddTargetHourToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :target_hour, :integer
  end
end
