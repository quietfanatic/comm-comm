class MainController < ApplicationController
  def topic
    @user = User.find_by_session(session['session_id'])
    if not @user
      redirect_to '/login/entrance'
    else
      @email = @user.email
      @posts = Post.order(:post_date)
    end
  end
end
