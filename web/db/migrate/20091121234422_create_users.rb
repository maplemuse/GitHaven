class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :hashed_password
      t.string :salt
      t.string :email
      t.string :url
      t.string :avatar

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
