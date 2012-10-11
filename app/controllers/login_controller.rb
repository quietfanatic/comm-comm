class LoginController < ApplicationController
  def entrance
  end
  def login
    user = User.find_by_email(params["email"])
    if user
      if user.password == params["password"]
        @redirect = "/main/topic"
      else
        @redirect = "/login/entrance?state=incorrect"
      end
    else
      new_user = User.new(email: params["email"])
      new_user.password = params["password"]
      new_user.save!
    end
  end
end
