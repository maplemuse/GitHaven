class CreateRepositories < ActiveRecord::Migration
  def self.up
    create_table :repositories do |t|
      t.integer :user_id, :null => false, :options => "CONSTRAINT fk_line_item_users REFERENCES users(id)"
      t.string :name
      t.string :description
      t.string :defaultbranch

      t.timestamps
    end
  end

  def self.down
    drop_table :repositories
  end
end
