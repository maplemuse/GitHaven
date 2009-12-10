require 'grit'

class Repository < ActiveRecord::Base
  belongs_to :user
  has_many :permissions, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  validates_format_of :name, :with => /\A[^\\'"`<>|; \t\n\(\)\[\]\?#\$^&*.\/]*\Z/, :message => 'Invalid characters'

  validate :existing_branch_name

  def authorized(user)
    return true if user && self.user == user
    permissions.each { |p|
      return true if user && p.user_id == user.id
      return true if p.user.username == I18n.t('user.all')
    }
    return false
  end

  def location
    config = Rails::Configuration.new
    location = config.root_path + '/../repos/' + user.username + '/' + name + '.git'
    return location
  end

private
  def existing_branch_name
    if self.defaultbranch.empty?
        return
    end
    puts self.defaultbranch

    repo = Grit::Repo.new(location)
    branches = repo.branches()
    found = false
    branches.each do |b|
        if b.name == self.defaultbranch
          found = true
        end
    end
    puts self.defaultbranch
    puts found
    errors.add(:defaultbranch, 'does not exists in the repository') if !found
    rescue
  end

end
