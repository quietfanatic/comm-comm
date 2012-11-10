class PostController < ApplicationController
  def new
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if params['content'] and params['content'] =~ /\S/
        if !Post.last or Post.last.content != params['content']
          @post = Post.create(content: params['content'], owner: @user.id, topic: @topic ? @topic.id : nil )
          if @topic
            @topic.last_activity = @post.id
            @topic.save!
          end
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
        Post.create(post_type: Post::PINNING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
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
        Post.create(post_type: Post::UNPINNING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
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
  def yell
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.yelled = true
        post.save!
        topic = Topic.find_by_id(post.topic)
        Post.create(post_type: Post::YELLING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
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
  def unyell
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.yelled = false
        post.save!
        topic = Topic.find_by_id(post.topic)
        Post.create(post_type: Post::UNYELLING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
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

end
