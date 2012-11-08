require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessible :email, :username, :visible_name, :is_confirmed, :can_edit_topics, :can_edit_posts, :can_edit_users, :can_confirm_users
  attr_protected :session

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new)
    @password = Password.create(new)
    self.password_digest = @password
  end
end
