class Topic < ActiveRecord::Base
    attr_accessible :name, :last_activity, :order
end
