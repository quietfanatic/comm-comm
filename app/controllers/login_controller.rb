class LoginController < ApplicationController
  def entrance
  end
  def login
    session[:owner] = params["email"]
    user = User.find_by_email(params["email"])
    if user
      if user.password == params["password"]
        @redirect ="/main/topic"
      else
        @redirect ="/login/entrance?state=incorrect"
      end
    else
      @redirect = "/login"
    end

  end
end
