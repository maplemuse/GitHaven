class AddUrlToRepository < ActiveRecord::Migration
  def self.up
    add_column :repositories, :url, :string
  end

  def self.down
    remove_column :repositories, :url
  end
end
