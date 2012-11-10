class MainController < ApplicationController
  def topic
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      ppp = 50
      @posts = Post.where(topic: @topic ? @topic.id : nil)
      @posts = @posts.order('created_at desc').limit(ppp).reverse

      if @topic
        @pinned = Post.order(:created_at).where(
          topic: @topic.id, pinned: true
        )
      else
        @pinned = Post.order(:created_at).where(
          topic: nil, pinned: true
        )
      end
      @indicators = Topic.all.select{ |t|
        updated_to = TopicUser.get(t, @user).updated_to || 0
        t.last_activity && t.last_activity > updated_to
      }.map{|t|t.id} || []
      if @topic
        topic_user = TopicUser.get(@topic, @user)
        topic_user.updated_to = @topic.last_activity
        topic_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
    ppp = 50 # posts_per_page
    if @posts && @posts.length > ppp
      len = @posts.length
      start = @posts.length - ppp
      @posts = @posts[start...len]
    end

  end
  def settings
    @user = User.logged_in(session)
    if @user
      if @user.can_edit_topics
        @topics = Topic.order('"order", "id"').all
      end
      if @user.can_edit_users or @user.can_confirm_users
        @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL")
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def update
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if since = params["since"].to_i
        if @topic
          @new_posts = Post.order(:created_at).where(
            "topic = :topic AND id > :since",
            topic: @topic.id, since: since
          )
        else
          @new_posts = Post.order(:created_at).where(
            "topic IS NULL AND id > :since",
            since: since
          )
        end
      else
        @new_posts = []
      end
      @indicators = Topic.all.select{ |t|
        updated_to = TopicUser.get(t, @user).updated_to || 0
        t.last_activity && t.last_activity > updated_to
      }.map{|t|t.id}
      if @topic
        topic_user = TopicUser.get(@topic, @user)
        topic_user.updated_to = @topic.last_activity
        topic_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
  end
end
