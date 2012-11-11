class MainController < ApplicationController

  PPP = 50  # Posts per page

  def topic
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      @posts = Post.where(topic: @topic ? @topic.id : nil)
      @posts = @posts.order('id desc').limit(PPP).reverse

      if @topic
        @pinned = Post.order(:id).where(
          topic: @topic.id, pinned: true
        )
      else
        @pinned = Post.order(:id).where(
          topic: nil, pinned: true
        )
      end
      if @topic
        topic_user = TopicUser.get(@topic, @user)
        topic_user.updated_to = @topic.last_activity
        topic_user.save!
      end
    else
      redirect_to '/login/entrance'
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
          @new_posts = Post.order(:id).where(
            '"topic" = :topic AND "id" > :since',
            topic: @topic.id, since: since
          )
        else
          @new_posts = Post.order(:id).where(
            '"topic" IS NULL AND "id" > :since',
            since: since
          )
        end
      else
        @new_posts = []
      end
      if @topic
        topic_user = TopicUser.get(@topic, @user)
        topic_user.updated_to = @topic.last_activity
        topic_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def backlog
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if before = params["before"].to_i
        if @topic
          @old_posts = Post.order('id desc').where(
            '"topic" = :topic AND "id" < :before',
            topic: @topic.id, before: before
          ).limit(PPP).all
        else
          @old_posts = Post.order('id desc').where(
            '"topic" IS NULL AND "id" < :before',
            before: before
          ).limit(PPP).all
        end
        @old_posts.reverse! if @old_posts
      end
    else
      redirect_to '/login/entrance'
    end
  end
end
