class TopicController < ApplicationController
  def new
    @current_user = User.find_by_session(session['session_id'])
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
