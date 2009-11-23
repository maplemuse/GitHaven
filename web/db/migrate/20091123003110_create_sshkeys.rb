class CreateSshkeys < ActiveRecord::Migration
  def self.up
    create_table :sshkeys do |t|
      t.string :name
      t.text :key, :null => false
      t.integer :user_id, :null => false, :options => "CONSTRAINT fk_line_item_users REFERENCES users(id)"
      t.timestamps
    end
  end

  def self.down
    drop_table :sshkeys
  end
end
