class LoginController < ApplicationController
  def entrance
  end
  def login
    user = User.find_by_email(params["email"])
    if user
      if user.password == params["password"]
        user.session = session['session_id']
        user.save!
        @redirect ="/main/topic"
      else
        @redirect ="/login/entrance?state=incorrect"
      end
    else
      @redirect = "/login/entrance?state=incorrect"
    end
  end
  def journey
    if (params['email'] and params['password'] and params['password'] == params['confirm_password'])
      unless User.find_by_email(params['email'])
        @user = User.create(:email => params["email"], :password => params['confirm_password'])
      end
    else
      redirect_to "/login/signup?state=password_mismatch"
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
    redirect_to "/login/entrance?state=logout"
  end
end
