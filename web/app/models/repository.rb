class Repository < ActiveRecord::Base
  belongs_to :user
  has_many :permissions, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  validates_format_of :name, :with => /\A[^\\'"`<>|; \t\n\(\)\[\]\?#\$^&*.\/]*\Z/, :message => 'Invalid characters'
end
