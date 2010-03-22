class Tag < ActiveRecord::Base
  belongs_to :repository
  validates_presence_of :tag
end
