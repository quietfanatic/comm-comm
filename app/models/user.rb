require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  attr_accessible :email, :username, :visible_name, :is_confirmed, :can_edit_boards, :can_edit_posts, :can_edit_users, :can_confirm_users, :can_change_appearance, :can_change_site_settings, :can_mail_posts, :exiled
  attr_protected :session

  def name
    return visible_name if visible_name
    email.match(/^([^@]+)/)
    return $1 if $1
    return "an ineffable user"
  end

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new)
    @password = Password.create(new)
    self.password_digest = @password
  end

  def self.logged_in(session)
    return false unless session.has_key?('session_id')
    user = User.find_by_session(session['session_id'])
    return false unless user
    return false unless user.is_confirmed
    return user
  end

  def self.any_unconfirmed?
    return User.find_by_is_confirmed(nil)
  end

end
