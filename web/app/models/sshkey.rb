class Sshkey < ActiveRecord::Base
  after_save :update_authorizedkeys
  after_destroy :update_authorizedkeys

  belongs_to :user
  validates_presence_of :name
  validates_presence_of :key
  validates_uniqueness_of :name, :scope => :user_id
  validates_uniqueness_of :key, :scope => :user_id
  validates_format_of :key, :with => /(ssh-rsa|ssh-dss) /, :message => I18n.t('sshkey.notsshkey')

  def update_authorizedkeys
    system('githaven-generateauthorizedkeys &')
  end
end
