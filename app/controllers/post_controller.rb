class PostController < ApplicationController
  def new
    @topic = Topic.find_by_name(params['topic'])
    @user = User.find_by_session(session['session_id'])
    if !Post.last || Post.last.content != params['content']
      Post.create(content: params['content'], post_date: DateTime.now, owner: @user.id, topic: @topic ? @topic.id : nil )
    end
    if @topic
      redirect_to "/main/topic?topic=#{URI.escape(@topic.name)}"
    else
      redirect_to '/main/topic'
    end
  end

  def pin
    post = Post.find_by_id(params['id'])
    if post
      post.pinned = true
      post.save!
      topic = Topic.find_by_id(post.topic)
      if topic
        redirect_to "/main/topic?topic=#{URI.escape(topic.name)}"
      else
        redirect_to "/main/topic"
      end
    else
      redirect_to "/main/topic"
    end
  end
  def unpin
    post = Post.find_by_id(params['id'])
    if post
      post.pinned = false
      post.save!
      topic = Topic.find_by_id(post.topic)
      if topic
        redirect_to "/main/topic?topic=#{URI.escape(topic.name)}"
      else
        redirect_to "/main/topic"
      end
    else
      redirect_to "/main/topic"
    end
  end

  def edit
  end

  def delete
    Post.destroy(id: params['id'])
  end

  def list
    @topic = Topic.find_by_name(params['topic'])
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
  end
end
