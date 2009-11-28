class Permission < ActiveRecord::Base
  belongs_to :repository
  belongs_to :user
  validates_presence_of :mode
  validates_uniqueness_of :user_id, :scope => :repository_id

  MODES = [
    [ "Read Only", "ro" ],
    [ "Read And Write", "rw" ]
  ]
  validates_inclusion_of :mode, :in => MODES.map {|disp, value| value}
end
