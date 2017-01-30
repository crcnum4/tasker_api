class AddUserIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :user_id, :int
  end
end
