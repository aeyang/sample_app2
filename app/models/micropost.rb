class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  
  #Setting up the order. Like SQL order by DESC command
  default_scope :order => 'microposts.created_at DESC'
end

# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

