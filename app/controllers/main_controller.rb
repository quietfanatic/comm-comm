class MainController < ApplicationController
  def topic
    @user = User.find_by_session(session['session_id'])
    @email = @user.email
    @posts = Post.order(:post_date)
  end
end
