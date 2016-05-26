class GroupList < ActiveRecord::Base
  belongs_to :user
  belongs_to :school
  serialize :list

  DEFAULT = %w(general controversial news events funny greeks sports missedconnections dartsandpats nerdtalk)

  def self.default_list
    DEFAULT
  end
end
