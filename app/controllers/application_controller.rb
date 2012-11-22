class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def logged_in?
    if session and session.has_key?('session_id')
      @session = Session.where(token: session['session_id']).first
      if @session
         # We're suspicious if the user agent is different but the session token is not
        if @session.user_agent.byteslice(0, 250) == request.env['HTTP_USER_AGENT'].byteslice(0, 250)
          @user = User.find_by_id(@session.user_id)
          if @user and @user.is_confirmed
            Rails.logger.warn("Logged in user: #{@user.id} (#{@user.email})\n")
            return true
          elsif @user
            Rails.logger.warn("Logged in user is not confirmed: #{@user.id} (#{@user.email})\n")
            return false
          else
            Rails.logger.warn("Session did not corresponde to valid user.\n")
            return false
          end
        else
          Rails.logger.warn(
            "User agent was changed during session; forcing logout.\n" +
            "Old: #{@session.user_agent.byteslice(0, 250)}\n" +
            "New: #{request.env['HTTP_USER_AGENT'].byteslice(0, 250)}\n"
          )
          @session.destroy  # Though the usual cause will be browser upgrade
          @session = nil
          @user = nil
          return false
        end
      else
        Rails.logger.warn("Not logged in.\n")
        @session = nil
        @user = nil
        return false
      end
    else
      Rails.logger.warn("Not logged in.\n")
      @session = nil
      @user = nil
      return false
    end
  end

  def logged_in (&block)
    if logged_in?
      block.call
      return true
    elsif @user
      redirect_to '/login/journey'
      return false
    else
      redirect_to '/login/entrance'
      return false
    end
  end

end
