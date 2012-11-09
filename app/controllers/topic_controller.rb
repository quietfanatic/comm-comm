class TopicController < ApplicationController
  def new
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_topics
        @name = params['name']
        if @name
          Topic.create(name: @name)
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
