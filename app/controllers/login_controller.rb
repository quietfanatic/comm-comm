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
end
