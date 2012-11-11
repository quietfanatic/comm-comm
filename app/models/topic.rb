class Topic < ActiveRecord::Base
    attr_accessible :name, :last_post, :last_event, :last_yell, :order
end
