class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user_id, :updated_to

  def self.get (topic, user)
    return TopicUser.where(
      topic: topic.id, user_id: user.id
    ).first_or_create(topic: topic.id, user_id: user.id)
  end

  OFF = "indicator"
  EVENT = "indicator got_event"
  POST = "indicator got_post"
  YELL = "indicator got_yell"
  REPLY = "indicator got_reply"


  def self.indicators (user)
    indicators = []
    for tu in TopicUser.find_all_by_user_id(user.id)
      mytop = Topic.find_by_id(tu.topic)
      if (mytop.last_activity and mytop.last_activity > tu.updated_to)
        indicators[tu.topic] = POST
      else
        indicators[tu.topic] = OFF
      end
    end
    return indicators
  end


end
