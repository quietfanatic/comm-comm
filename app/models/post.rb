class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :topic, :pinned, :yelled, :post_type, :reference
   # These constants enumerate the different types of posts
   # You can add new types, but you cannot reorder types that are already here!
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
  TOPIC_REORDERING = 12

  def is_normal
    return post_type == nil || post_type == NORMAL || post_type == REPLY
  end
  def is_event
    return !is_normal
  end

  def self.ref_link (ref, text, user)
    post = Post.find_by_id(ref.to_i)
    return text unless post
    cssclass = "postref"
    cssclass += " at_you" if user and post.owner == user.id
    cssclass += " event" if post.is_event
    return "<a class=\"#{cssclass}\" onClick=\"show_post(#{ref})\">#{text}</a>"
  end

  def event_string (user)
    case post_type
    when nil
      return " wrote"
    when NORMAL
      return " wrote"  # This and reply probably won't be shown
    when REPLY
      return " replied to " + Post.ref_link(reference.to_s, reference.to_s, user)
    when PINNING
      return " pinned " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when UNPINNING
      return " unpinned " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when MAILING
      return " mailed " + Post.ref_link(reference.to_s, reference.to_s, user)
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
        return " confirmed " + confirmed_user.name
      else
        return " confirmed...somebody I can't find any more"
      end
    when USER_EDITING
      edited_user = User.find_by_id(reference)
      if (edited_user)
        return " edited " + edited_user.name
      else
        return " edited...somebody I can't find any more"
      end
    when YELLING
      return " yelled " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when UNYELLING
      return " unyelled " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when TOPIC_REORDERING
      return " reordered " + content
    else
      return " generated a mysterious post"
    end
  end

  Lit_Tag_Matcher = ['b', 'i', 'u', 's', 'del', 'ins', 'code']

  def html_content (user)
    return '' unless content;
    html = content
    html.gsub!(/[<>&"']/, '<' => '&lt;', '>' => '&gt;', '&' => '&amp;', '"' => '&quot;', "'" => '&apos;')
    for lit in Lit_Tag_Matcher
      html.gsub!(/\[#{lit}\](.*?)\[\/#{lit}\]/mi, "<#{lit}>\\1</#{lit}>")
    end
    html.gsub!(/\[size=(&quot;|&apos;|)(\d+(?:\.\d+)?)\1\](.*?)\[\/size\]/mi, '<span style="font-size: \2em">\3</span>')
    html.gsub!(/\[size=(&quot;|&apos;|)([^\]]*)\1\](.*?)\[\/size\]/mi, '<span style="font-size: \2">\3</span>')
    html.gsub!(/\[url\](.*?)\[\/url\]/mi, '<a href="\1">\1</a>')
    html.gsub!(/\[url=(&quot;|&apos;|)([^\]]*)\1\](.*?)\[\/url\]/mi, '<a href="\2">\3</a>')
    html.gsub!(/\[img\](.*?)\[\/img\]/mi, '<img src="\1" style="max-width: 320px; max-height: 320px;" alt="\1"/>')
    html.gsub!(/\[color=(&quot;|&apos;|)([^\]]*)\1\](.*?)\[\/color\]/mi, '<span style="color: \2">\3</span>')
    html.gsub!(/(\A|[^"a-zA-Z])([a-zA-Z]+:\/\/[^\s<]+)/, '\1<a href="\2">\2</a>')
    html.gsub! /&gt;&gt;(\d+)/ do |m|
      Post.ref_link($1, '&gt;&gt;' + $1, user)
    end
    return html;
  end

end
