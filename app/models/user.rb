require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessible :email, :username, :visible_name, :is_confirmed
  attr_protected :session

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new)
    @password = Password.create(new)
    self.password_digest = @password
  end
end
