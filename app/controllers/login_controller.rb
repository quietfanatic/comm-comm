class LoginController < ApplicationController
  def entrance
  end
  def login
    user = User.find_by_email(params["email"])
    if user and session.has_key?('session_id')
      if user.password == params["password"]
        Session.create(user_id: user.id, token: session['session_id'], user_agent: request.env['HTTP_USER_AGENT'])
        initial = SiteSettings.first_or_create.initial_board
        if initial
          redirect_to "/main/board?board=#{initial}"
        else
          redirect_to "/main/board"
        end
      else
        redirect_to "/login/entrance?error=Sorry,+one+of+those+was+a+bit+wrong."
      end
    else
      redirect_to "/login/entrance?error=Sorry,+one+of+those+was+a+bit+wrong."
    end
  end
  def journey
    if params['email'] !~ /\S/
      redirect_to "/login/signup?error=Sorry,+you+must+provide+an+email+address."
    elsif params['email'] !~ /^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+$/
      redirect_to "/login/signup?error=Sorry,+that+email+address+wasn't+accepted."
    elsif params['name'] !~ /\S/
      redirect_to "/login/signup?error=Sorry,+you+must+provide+a+name+for+yourself."
    elsif params['password'] !~ /\S/
      redirect_to "/login/signup?error=Sorry,+you+must+provide+a+password."
    elsif params['password'].length < 6
      redirect_to "/login/signup?error=Sorry,+your+pasword+must+be+at+least+six+characters+long."
    elsif params['confirm_password'] !~ /\S/
      redirect_to "/login/signup?error=Sorry,+you+must+confirm+your+password."
    elsif params['password'] != params['confirm_password']
      redirect_to "/login/signup?error=Sorry,+your+passwords+didn't+match."
    elsif User.find_by_email(params['email'])
      redirect_to "/login/signup?error=Sorry,+That+email+address+is+in+use."
    else
      @user = User.create(
        email: params['email'],
        visible_name: params['name'],
        password: params['password']
      )
      Session.create(user_id: @user.id, token: session['session_id'], user_agent: request.env['HTTP_USER_AGENT'])
    end
  end
  def signup
  end
  def logout
    sess = Session.find_by_token(session['session_id'])
    if sess
      sess.destroy
    end
    redirect_to "/login/entrance?notice=You+have+been+logged+out."
  end
end
