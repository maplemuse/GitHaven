require 'digest/sha1'

class User < ActiveRecord::Base
  is_gravtastic!(:source => "avatar")
  has_many :repositories
  has_many :sshkeys

  validates_presence_of   :username
  validates_uniqueness_of :username
  validates_presence_of   :email

  attr_accessor :password_confirmation
  validates_confirmation_of   :password
  attr_protected :hashed_password
  validates_format_of :email, :with => /\A.+@.+\Z/, :message => 'Invalid email address'
  validates_format_of :username, :with => /\A[^\\'"`<>|; \t\n\(\)\[\]\?#\$^&*.]*\Z/, :message => 'Invalid characters'

  validate :password_non_blank

  def self.authenticate(username, password)
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

private
  def self.encrypted_password(password, salt)
    string_to_hash = password + 'paris' + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def password_non_blank
    errors.add(:password, 'Missing password') if hashed_password.blank?
  end

end
