class MainController < ApplicationController
  def topic
    @user = User.find_by_session(session['session_id'])
    if @user
      if @user.is_confirmed
        @email = @user.email
        @posts = Post.order(:post_date)
      else
        redirect_to "/login/journey"
      end
    else
      redirect_to '/login/entrance'
    end
  end
end
