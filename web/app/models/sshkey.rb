class Sshkey < ActiveRecord::Base
  after_save :update_authorizedkeys
  after_destroy :update_authorizedkeys

  belongs_to :user
  validates_presence_of :name
  validates_presence_of :key
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :key, :scope => :user_id

  def update_authorizedkeys
    config = Rails::Configuration.new
    location = config.root_path + '/../bin/gitforest-generateauthorizedkeys'
    system(location)
  end
end
