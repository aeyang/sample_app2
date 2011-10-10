class User < ActiveRecord::Base
	attr_accessor   :password
	attr_accessible :name, :email, :password, :password_confirmation
	#put anything that is received from the web in attr_accessible
    
    email_regex = /\A[\w+.\-]+@[a-z.\d\-]+\.[a-z]+\z/i

	validates :name, :presence => true, 
	                 :length => { :maximum => 50 }

	validates :email, :presence => true, 
	                  :format => { :with => email_regex },
	                  :uniqueness => { :case_sensitive => false }

	validates :password, :presence => true,
						 :confirmation => true,
						 #The line above both creates a password_confirmation attribute
						 #and makes sure that it matches the password attribute...somehow
 					     :length => { :within => 6..40 }
end


# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

