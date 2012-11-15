class UserController < ApplicationController
  def confirm
    logged_in do
      if @user.can_confirm_users
        confirmee = User.find_by_id(params['id'])
        if confirmee and not confirmee.is_confirmed
          if params['do'] == 'confirm'
            confirmee.is_confirmed = true
            confirmee.save!
          elsif params['do'] == 'deny'
            confirmee.destroy
          end
        end
      end
      redirect_to '/main/settings'
    end
  end
  def edit
    logged_in do
      editee = User.find_by_id(params['id'])
      if editee and (@user.can_edit_users or @user.id == editee.id)
        if params['email']
          editee.email = params['email']
        end
        if params['name']
          editee.visible_name = params['name']
        end
        editee.save!
      end
      redirect_to '/main/settings'
    end
  end
end
