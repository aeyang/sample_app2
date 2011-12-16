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
 
    #register callback method encrypt_password
    before_save :encrypt_password

    def has_password?(submitted_password)
       encrypted_password == encrypt(submitted_password)
    end

    #Class Method
    def self.authenticate(email, submitted_password)
       user = find_by_email(email) #Can omit 'User'.find_by_email since we are in the User class already
       return nil if user.nil?
       return user if user.has_password?(submitted_password)
    end
    
    #Class method for session authentication to use. Compares User cookie data with Db data for match
    def self.authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end

    #private method
    private 
      
      def encrypt_password
      	#ActiveRecord boolean new_record?. Will only run salt if its a new record
        self.salt = make_salt if new_record? 
      	self.encrypted_password = encrypt(password)
      end

      def encrypt(string)
      	secure_hash("#{salt}--#{string}")
      end

      def secure_hash(string)
        Digest::SHA2.hexdigest(string)
      end

      def make_salt
      	secure_hash("#{Time.now.utc}--{password}")
      end
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
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

