class Sshkey < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name
  validates_presence_of :key
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :key, :scope => :user_id
end
