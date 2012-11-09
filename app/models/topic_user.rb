class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user, :updated_to

  def self.get (topic, user)
    got = TopicUser.where(
      "topic = :topic AND user = :user",
      topic: topic.id, user: user.id
    )
    return got if got
    return TopicUser.create(topic: topic.id, user: user.id)
  end

end
