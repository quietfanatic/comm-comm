class UserController < ApplicationController
  def confirm
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_confirm_users
        @user = User.find_by_id(params['id'])
        if @user and not @user.is_confirmed
          if params['do'] == 'confirm'
            @user.is_confirmed = true
            @user.save!
          elsif params['do'] == 'deny'
            @user.delete
          end
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
  def edit
    @current_user = User.logged_in(session)
    if @current_user
      @user = User.find_by_id(params['id'])
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
