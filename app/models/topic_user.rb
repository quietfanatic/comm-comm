class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user, :updated_to

  def self.get (topic, user)
    return TopicUser.where(
      "topic == :topic AND user == :user",
      topic: topic.id, user: user.id
    ).first_or_create(topic: topic.id, user: user.id)
  end

end
