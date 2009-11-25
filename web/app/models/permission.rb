class Permission < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => :repository_id
end
