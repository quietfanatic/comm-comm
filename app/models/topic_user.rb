class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user_id, :updated_to

  def self.get (topic, user)
    return TopicUser.where(
      topic: topic.id, user_id: user.id
    ).first_or_create(topic: topic.id, user_id: user.id)
  end

end
