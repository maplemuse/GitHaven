class Repository < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name

  def owner
    User.find(user_id)
    rescue
    nil
  end

end
