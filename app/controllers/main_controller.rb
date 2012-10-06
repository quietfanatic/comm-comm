class MainController < ApplicationController
  def topic
    @posts = Post.order(:post_date)
  end
end
