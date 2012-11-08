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
  def edit
    @current_user = User.find_by_session(session['session_id'])
    @user = User.find_by_id(params['id'])
    if @current_user
      if @user and @current_user.is_confirmed and (@current_user.can_edit_users or @current_user.id == @user.id)
        if @user
          if params['email']
            @user.email = params['email']
          end
          if params['name']
            @user.visible_name = params['name']
          end
          @user.save!
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
