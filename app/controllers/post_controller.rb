class PostController < ApplicationController
  def new
    @user = User.find_by_session(session['session_id'])
    if !Post.last || Post.last.content != params['content']
      Post.create(content: params['content'], post_date: DateTime.now, owner: @user.id)
    end
  end

  def edit
  end

  def delete
    Post.destroy(id: params['id'])
  end

  def list
    if since = params["since"].to_i
      @new_posts = Post.all.select{|p| p.id > since}
    else
      @new_posts = []
    end
    render layout: false
  end
end
