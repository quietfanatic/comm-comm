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
      @redirect = "/login"
    end
  end
  def journey
    if (params['password'] == params['confirm_password'])
      @user = User.create(:email => params["email"], :password => params['confirm_password'])
    else
      redirect_to "/login/signup?state=password_mismatch"
    end
  end
  def signup
  end
end
