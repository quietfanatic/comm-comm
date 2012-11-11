class TopicController < ApplicationController
  def new
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_topics
        name = params['name']
        if name and name =~ /\S/
          topic = Topic.new(name: name)
          topic.save!
          Post.create(
            post_type: Post::TOPIC_CREATION,
            topic: topic.id,
            reference: topic.id,
            owner: @current_user.id,
            content: topic.name
          )
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
  def edit
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_topics
        topic = Topic.find_by_id(params['id'])
        if topic
          if params['do'] == 'change'
            name = params['name']
            if name and name =~ /\S/ and name != topic.name
              oldname = topic.name
              topic.name = name
              topic.save!
              Post.create(
                post_type: Post::TOPIC_RENAMING,
                topic: topic.id,
                reference: topic.id,
                owner: @current_user.id,
                content: oldname + "\n" + topic.name
              )
            end
            order = params['order']
            if order and order != topic.order
              topic.order = order
              topic.save!
              Post.create(
                post_type: Post::TOPIC_REORDERING,
                topic: topic.id,
                reference: topic.id,
                owner: @current_user.id,
                content: topic.name
              )
            end
          elsif params['do'] == 'delete'
             # Deletion of topics is NYI
          end
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
