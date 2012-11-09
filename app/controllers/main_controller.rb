class MainController < ApplicationController
  def topic
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
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
    else
      redirect_to '/login/entrance'
    end
  end
  def settings
    @user = User.logged_in(session)
    if @user
      if @user.can_edit_topics
        @topics = Topic.all
      end
      if @user.can_edit_users or @user.can_confirm_users
        @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL")
      end
    else
      redirect_to '/login/entrance'
    end
  end
end
