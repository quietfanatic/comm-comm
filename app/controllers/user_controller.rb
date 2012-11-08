class UserController < ApplicationController
  def confirm
    @user = User.find_by_id(params['id'])
    if @user
      @user.is_confirmed = true
      @user.save!
    end
    redirect_to '/main/settings'
  end
end
