class LoginController < ApplicationController
  def entrance
  end
  def login
    unless User.find_by_email(params["email"])
      new_user = User.new(email: params["email"])
      new_user.password = params["password"]
      new_user.save!
    end
  end
end
