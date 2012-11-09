class TopicUser < ActiveRecord::Base
  attr_accessible :topic, :user, :updated_to
end
