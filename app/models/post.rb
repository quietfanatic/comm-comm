class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :topic, :pinned, :yelled, :post_type, :reference
   # These constants enumerate the different types of posts
  NORMAL = 0
  REPLY = 1  # These will probably be indistinguishable from NORMAL posts
  PINNING = 2
  UNPINNING = 3
  MAILING = 4
  TOPIC_CREATION = 5
  TOPIC_RENAMING = 6
  TOPIC_DELETION = 7
  USER_CONFIRMATION = 8
  USER_EDITING = 9
  YELLING = 10
  UNYELLING = 11

  def is_normal
    return post_type == nil || post_type == NORMAL || post_type == REPLY
  end
  def is_event
    return !is_normal
  end

  def event_string
    case post_type
    when nil
      return " wrote"
    when NORMAL
      return " wrote"  # This and reply probably won't be shown
    when REPLY
      return " replied to " + reference.to_s
    when PINNING
      return " pinned " + reference.to_s
    when UNPINNING
      return " unpinned " + reference.to_s
    when MAILING
      return " mailed " + reference.to_s
    when TOPIC_CREATION
      return " created " + content
    when TOPIC_RENAMING
      lines = content.split("\n")
      return " renamed " + lines[0] + " to " + lines[1]
    when TOPIC_DELETION
      return " deleted " + content
    when USER_CONFIRMATION
      confirmed_user = User.find_by_id(reference)
      if (confirmed_user)
        return " confirmed " + (confirmed_user.visible_name || confirmed_user.email)
      else
        return " confirmed...somebody I can't find any more"
      end
    when USER_EDITING
      edited_user = User.find_by_id(reference)
      if (edited_user)
        return " edited " + (edited_user.visible_name || edited_user.email)
      else
        return " edited...somebody I can't find any more"
      end
    when YELLING
      return " yelled " + reference.to_s
    when UNYELLING
      return " unyelled " + reference.to_s
    else
      return " generated a post I have no idea what to do with"
    end
  end


end
