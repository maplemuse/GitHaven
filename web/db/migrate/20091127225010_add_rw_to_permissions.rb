class AddRwToPermissions < ActiveRecord::Migration
  def self.up
    add_column :permissions, :mode, :string, :default => "rw", :null => false
  end

  def self.down
    remove_column :mode
  end
end
