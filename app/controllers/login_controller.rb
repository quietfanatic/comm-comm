class LoginController < ApplicationController
  def entrance
  end
  def login
    user = User.find_by_email(params["email"])
    if user
      if user.password == params["password"]
        user.session = session['session_id']
        user.save!
        redirect_to "/main/topic"
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
    end
  end
  def signup
  end
  def logout
    user = User.find_by_session(session['session_id'])
    if user
      user.session = nil
      user.save!
    end
    redirect_to "/login/entrance?notice=You+have+been+logged+out."
  end
end
