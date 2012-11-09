class PostController < ApplicationController
  def new
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if !Post.last || Post.last.content != params['content']
        @post = Post.create(content: params['content'], post_date: DateTime.now, owner: @user.id, topic: @topic ? @topic.id : nil )
        if @topic
          @topic.last_activity = @post.id
          @topic.save!
        end
      end
      if @topic
        redirect_to "/main/topic?topic=#{@topic.id}"
      else
        redirect_to '/main/topic'
      end
    else
      redirect_to '/login/entrance'
    end
  end

  def pin
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.pinned = true
        post.save!
        topic = Topic.find_by_id(post.topic)
        if topic
          redirect_to "/main/topic?topic=#{topic.id}"
        else
          redirect_to "/main/topic"
        end
      else
        redirect_to "/main/topic"
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def unpin
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.pinned = false
        post.save!
        topic = Topic.find_by_id(post.topic)
        if topic
          redirect_to "/main/topic?topic=#{topic.id}"
        else
          redirect_to "/main/topic"
        end
      else
        redirect_to "/main/topic"
      end
    else
      redirect_to '/login/entrance'
    end
  end

  def edit
  end

  def delete
  end

  def list
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if since = params["since"].to_i
        if @topic
          @new_posts = Post.order(:post_date).where(
            "topic = :topic AND id > :since",
            topic: @topic.id, since: since
          )
        else
          @new_posts = Post.order(:post_date).where(
            "id > :since", since: since
          )
        end
      else
        @new_posts = []
      end
      render file: "../views/post/list.xml.erb", layout: false
    else
      redirect_to '/login/entrance'
    end
  end
end
