class PostController < ApplicationController
  def new
    @user = User.logged_in(session)
    if @user
      @topic = Topic.find_by_id(params['topic'])
      if params['content'] and params['content'] =~ /\S/
        if !Post.last or Post.last.content != params['content']
          @post = Post.new(content: params['content'], owner: @user.id, topic: @topic ? @topic.id : nil )
          @post.save!
          if @topic
            @topic.last_post = @post.id
            @topic.save!
            for ref in @post.scan_for_refs
              @reffed = Post.find_by_id(ref)
              if @reffed and @reffed.owner
                tu = TopicUser.get_by_ids(@topic.id, @reffed.owner)
                tu.last_reply = @post.id
                tu.save!
              end
            end
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
        event = Post.new(post_type: Post::PINNING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_event = event.id;
          topic.save!
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
        event = Post.new(post_type: Post::UNPINNING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_event = event.id;
          topic.save!
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
        Rails.logger.warn post.yelled
        topic = Topic.find_by_id(post.topic)
        event = Post.new(post_type: Post::YELLING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_yell = event.id;
          topic.save!
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
        event = Post.new(post_type: Post::UNYELLING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_event = event.id;
          topic.save!
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
  def hide
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.hidden = true
        post.save!
        topic = Topic.find_by_id(post.topic)
        event = Post.new(post_type: Post::HIDING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_event = event.id;
          topic.save!
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
  def unhide
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.hidden = false
        post.save!
        topic = Topic.find_by_id(post.topic)
        event = Post.new(post_type: Post::UNHIDING, reference: post.id, owner: @user.id, topic: topic ? topic.id : nil)
        event.save!
        if topic
          topic.last_event = event.id;
          topic.save!
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
