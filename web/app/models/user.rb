require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :repositories, :dependent => :destroy
  has_many :sshkeys, :dependent => :destroy

  validates_presence_of   :username
  validates_uniqueness_of :username
  validates_format_of :username, :with => /\A[^\\'"`<>|; \t\n\(\)\[\]\?#\$^&*.\/]*\Z/, :message => 'Invalid characters'

  validates_presence_of :email
  validates_format_of   :email, :with => /\A.+@.+\Z/, :message => 'Invalid email address'

  validate :password_non_blank
  attr_accessor :password_confirmation
  validates_confirmation_of :password
  attr_protected :hashed_password
  attr_protected :username

  def self.authenticate(username, password)
    # Never allow the Everyone user to login, everyone is really just a pretend group
    return nil if username == I18n.t('user.all')
    user = self.find_by_username(username)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def avatar_email
    puts self.email
    if self.avatar && !self.avatar.empty?
      return self.avatar
    end
    return self.email
  end

private
  def self.encrypted_password(password, salt)
    string_to_hash = password + 'paris' + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
    check_for_everyone
  end

  def password_non_blank
    errors.add(:password, 'Missing password') if hashed_password.blank?
  end

  def check_for_everyone
    create_user_everyone if User.count == 0
  end

  def create_user_everyone
    everyone = User.new
    everyone.username = I18n.t('user.all')
    everyone.password = ''
    everyone.save(false)
  end
end
