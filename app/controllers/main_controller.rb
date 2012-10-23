class MainController < ApplicationController
  def topic
    @user = User.find_by_session(session['session_id'])
    if @user
      @email = @user.email
      @posts = Post.order(:post_date)
    else
      redirect_to '/login/entrance'
    end
  end
end
