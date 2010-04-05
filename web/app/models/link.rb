class Link < ActiveRecord::Base
  belongs_to :repository
  validates_uniqueness_of :name, :scope => :repository_id
  validates_presence_of :name
  validates_presence_of :url
end
