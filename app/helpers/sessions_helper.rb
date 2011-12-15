module SessionsHelper


  def sign_in(user)
    
    #Rails stuff to remember users' sign in status... use user.salt to uniquely identify user
    #this puts a remember_token (cookie) securely on the browser.
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]

    #current_user= is a functino
    current_user = user;
  end

  #setter method for instance variable: current_user
  def current_user=(user)
    #declaring an instance variable
    @current_user = user
  end

  #getter method for current_user.
  def current_user
  	#We want @current_user to persist. It will be called many times and 
  	#we dont want to call user_from_remember_token every time because that method
  	#hits the database. 
  	#So, what ||= does is if @current_user is nil, user_from_remember_token will be 
  	#called and @current_user's value will be set. The next time current_user is called,
  	#@current_user already has a value and so user_from_remember_token will not be called.
  	@current_user ||= user_from_remember_token
  end 

  #check if user is signed in
  def signed_in?
    #Why current_user and not @current_user??? what is the difference?
    !current_user.nil?
  end

  #signing out 
  def sign_out
  	#delete the cookie
  	cookies.delete(:remember_token)
  	current_user = nil
  end

  private
    
    #Calls the user method to find a user with the same credentials as in the remember token
    #The *remember_token splits the array one time, so it effectively is passing two arguments
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    #Gets the token out of the cookie. If no token, then returns [nil, nil]
    def remember_token
      #The || effectively returns [nil, nil] only if cookies.signed returns nil.
      cookies.signed[:remember_token] || [nil, nil]
    end

end
