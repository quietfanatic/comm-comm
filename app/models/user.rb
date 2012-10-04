class User < ActiveRecord::Base
  attr_accessible :email, :is_admin, :password, :username, :visible_name
end
