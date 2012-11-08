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
    @topic = Topic.find_by_name(params['topic'])
    @posts = Post.order(:post_date).find_all_by_topic(@topic ? @topic.id : nil)
    if @topic
      @pinned = Post.order(:post_date).where(
        "topic = :topic AND pinned = :pinned",
        topic: @topic, pinned: true
      )
    else
      @pinned = Post.order(:post_date).where(
        "topic IS NULL AND pinned = :pinned",
        pinned: true
      )
    end
  end
  def settings
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
    if @user.can_edit_topics
      @topics = Topic.all
    end
    if @user.can_edit_users or @user.can_confirm_users
      @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL")
    end
  end
end
