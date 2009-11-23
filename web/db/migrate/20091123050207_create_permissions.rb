class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.integer :repository_id, :null => false, :options => "CONSTRAINT fk_line_item_users REFERENCES repository(id)"
      t.integer :user_id, :null => false, :options => "CONSTRAINT fk_line_item_users REFERENCES users(id)"

      t.timestamps
    end
  end

  def self.down
    drop_table :permissions
  end
end
