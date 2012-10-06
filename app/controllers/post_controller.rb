class PostController < ApplicationController
  def new
    Post.create(content: params['content'], post_date: DateTime.now)
  end

  def edit
  end

  def delete
  end
end
