class AddTagToRepository < ActiveRecord::Migration
  def self.up
    add_column :repositories, :tag_id, :integer
  end

  def self.down
    remove_column :repositories, :tag_id
  end
end
