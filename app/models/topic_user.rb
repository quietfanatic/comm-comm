class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user_id, :updated_to, :last_reply

  def self.get_by_ids (tid, uid)
    return TopicUser.where(
      topic: tid, user_id: uid
    ).first_or_create(topic: tid, user_id: uid);
  end
  def self.get (topic, user)
    return get_by_ids(topic.id, user.id)
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
      if mytop
        if (tu.last_reply and tu.last_reply > tu.updated_to)
          indicators[tu.topic] = REPLY
        elsif (mytop.last_yell and mytop.last_yell > tu.updated_to)
          indicators[tu.topic] = YELL
        elsif (mytop.last_post and mytop.last_post > tu.updated_to)
          indicators[tu.topic] = POST
        elsif (mytop.last_event and mytop.last_event > tu.updated_to)
          indicators[tu.topic] = EVENT
        else
          indicators[tu.topic] = OFF
        end
      end
    end
    return indicators
  end


end
