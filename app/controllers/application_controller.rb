class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    @session = session && session.has_key?('session_id') ? Session.find_by_token(session['session_id']) : nil
    @user = @session ? User.find_by_id(@session.user_id) : nil
    return @session && @user && @user.is_confirmed
  end

  def logged_in (&block)
    if logged_in?
      block.call
      return true
    else
      redirect_to '/login/entrance'
      return false
    end
  end

end
