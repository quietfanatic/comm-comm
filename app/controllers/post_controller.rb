require 'digest/sha1'
class PostController < ApplicationController
  def new
    Post.create(content: params['content'], post_date: DateTime.now, owner: session[:owner])
  end

  def edit
  end

  def delete
    Post.destroy(id: params['id'])
  end
end
