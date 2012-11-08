class UserController < ApplicationController
  def confirm
    @current_user = User.find_by_session(session['session_id'])
    if @current_user
      if @current_user.is_confirmed and @current_user.can_confirm_users
        @user = User.find_by_id(params['id'])
        if @user
          @user.is_confirmed = true
          @user.save!
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
