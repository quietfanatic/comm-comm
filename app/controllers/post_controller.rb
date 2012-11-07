class PostController < ApplicationController
  def new
    @topic = Topic.find_by_name(params['topic'])
    @user = User.find_by_session(session['session_id'])
    if !Post.last || Post.last.content != params['content']
      Post.create(content: params['content'], post_date: DateTime.now, owner: @user.id, topic: @topic ? @topic.id : nil )
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
