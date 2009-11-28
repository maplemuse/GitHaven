class Repository < ActiveRecord::Base
  belongs_to :user
  has_many :permissions, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  validates_format_of :name, :with => /\A[^\\'"`<>|; \t\n\(\)\[\]\?#\$^&*.\/]*\Z/, :message => 'Invalid characters'

  def authorized(user)
    permissions.each { |p|
      return true if user && p.user_id == user.id
      return true if p.user.username == I18n.t('user.all')
    }
    return false
  end
end
