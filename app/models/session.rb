class Session < ActiveRecord::Base
  attr_accessible :user_id, :token, :user_agent

  
end
