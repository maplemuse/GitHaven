class AddForkToRepository < ActiveRecord::Migration
  def self.up
    add_column :repositories, :forked_repository_id, :integer
  end

  def self.down
    remove_column :repositories, :forked_repository_id
  end
end
