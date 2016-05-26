class Group < ActiveRecord::Base
  require 'active_support/core_ext/array/conversions.rb'
  has_many :posts, dependent: :destroy

  def self.find_with_tag(group, school)
    return nil if group.blank?
    my_group = where('tag = ? AND school = ?', group, school).first
    my_group ? my_group : try_create(group, school)
  end

  def self.try_create(group, school)
    return nil unless group =~ /\A[a-z0-9]{1,100}\z/
    create(tag: group, school: school)
  end
end
