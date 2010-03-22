class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :repository_id, :null => false, :options => "CONSTRAINT fk_line_item_repositories REFERENCES repository(id)"
      t.string :tag, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
