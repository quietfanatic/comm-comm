require 'digest/sha1'
class PostController < ApplicationController
  def new
    @user = User.find_by_session(session['session_id'])
    Post.create(content: params['content'], post_date: DateTime.now, owner: @user.id)
  end

  def edit
  end

  def delete
    Post.destroy(id: params['id'])
  end
end
