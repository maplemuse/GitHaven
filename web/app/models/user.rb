#
#   Copyright (C) 2010 Benjamin C. Meyer <ben@meyerhome.net>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require 'digest/sha1'
require 'digest/md5'

def gravatar_url_for(email, options)
    "http://www.gravatar.com/avatar.php?gravatar_id=" + Digest::MD5.hexdigest(email) + options
end

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
    if self.avatar && !self.avatar.empty?
      return self.avatar
    end
    return self.email
  end

  def gravatar_url(options)
    if self.username == I18n.t('user.all')
        # If the repository is private user.all wont be in its list.
        return 'public.png'
    end
    gravatar_url_for(self.avatar_email, options)
  end

  def forked(repository)
    return false if !repository
    return true if self == repository.user
    Repository.find_by_forked_repository_id(repository.id, :conditions => ['user_id = ?', self.id])
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
    everyone.name =  I18n.t('user.all')
    everyone.password = ''
    everyone.save(false)
  end
end
