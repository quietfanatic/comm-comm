class TopicController < ApplicationController
  def new
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_topics
        @name = params['name']
        if @name and @name =~ /\S/
          topic = Topic.new(name: @name)
          topic.save!
          Post.create(post_type: Post::TOPIC_CREATION, topic: topic.id, reference: topic.id, owner: @current_user, content: topic.name)
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
