class LoginController < ApplicationController
  def entrance
  end
  def login
    unless User.find_by_email(params["email"])
      new_user = User.create(email: params["email"], password_digest: params["password"])
    end
  end
end
