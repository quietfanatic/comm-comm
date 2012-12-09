class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :board, :pinned, :yelled, :post_type, :reference, :hidden
   # These constants enumerate the different types of posts
   # You can add new types, but you cannot reorder types that are already here!
  NORMAL = 0
  REPLY = 1  # UNUSED
  PINNING = 2
  UNPINNING = 3
  MAILING = 4
  BOARD_CREATION = 5
  BOARD_RENAMING = 6
  BOARD_DELETION = 7
  USER_CONFIRMATION = 8
  USER_EDITING = 9  # UNUSED
  YELLING = 10
  UNYELLING = 11
  BOARD_REORDERING = 12
  HIDING = 13
  UNHIDING = 14
  EDIT = 15
   # MAILING = 16 oops, made a duplicate
  BOARD_MERGING = 17
  BOARD_UNMERGING = 18
  APPEARANCE_CHANGING = 19
  EXILING = 20
  REINSTATION = 21

  def is_normal
    return post_type == nil || post_type == NORMAL || post_type == REPLY || post_type == EDIT
  end
  def is_event
    return !is_normal
  end
  def is_hidable (user)
    return !pinned && !hidden && (hidden == false || owner == user.id || content =~ /\[img\]/)
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
      return nil
    when NORMAL
      return nil
    when REPLY
      return " replied to " + Post.ref_link(reference.to_s, reference.to_s, user)
    when PINNING
      return " pinned " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when UNPINNING
      return " unpinned " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when MAILING
      return " mailed " + Post.ref_link(reference.to_s, reference.to_s, user)
    when BOARD_CREATION
      return " created " + content
    when BOARD_RENAMING
      lines = content.split("\n")
      return " renamed " + lines[0] + " to " + lines[1]
    when BOARD_DELETION
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
    when BOARD_REORDERING
      return " reordered " + (content || "a board whose name was lost to a bug")
    when HIDING
      return " hid " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when UNHIDING
      return " unhid " + Post.ref_link(reference.to_s, reference.to_s, nil)
    when EDIT
      return " edited " + Post.ref_link(reference.to_s, reference.to_s, user)
    when BOARD_MERGING
      lines = content.match(/(.*)\n(.*)/)
      return " merged " + lines[1] + " into " + lines[2]
    when BOARD_UNMERGING
      lines = content.match(/(.*)\n(.*)/)
      return " unmerged " + lines[1] + " from " + lines[2]
    when APPEARANCE_CHANGING
      return " changed the site appearance"
    when EXILING
      exiled_user = User.find_by_id(reference)
      if (exiled_user)
        return " exiled " + exiled_user.name
      else
        return " exiled...somebody I can't find any more"
      end
    when REINSTATION
      exiled_user = User.find_by_id(reference)
      if (exiled_user)
        return " reinstated " + exiled_user.name
      else
        return " reinstated...somebody I can't find any more"
      end
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
    html.gsub!(/\[img\](.*?)\[\/img\]/mi, '<img src="\1" style="max-width: 100%; max-height: 320px;" alt="\1"/>')
    html.gsub!(/\[wat\](.*?)\[\/wat\]/mi, '<img src="\1" style="max-width: 100%; max-height: 320px;" alt="\1"/>')
    html.gsub!(/\[color=(&quot;|&apos;|)([^\]]*)\1\](.*?)\[\/color\]/mi, '<span style="color: \2">\3</span>')
    html.gsub!(/(\A|[^"a-zA-Z])([a-zA-Z]+:\/\/[^\s<]+)/, '\1<a href="\2">\2</a>')
    html.gsub! /&gt;&gt;(\d+)/ do |m|
      Post.ref_link($1, '&gt;&gt;' + $1, user)
    end
    return html;
  end
  def text_content
    return '' unless content;
    text = content
    text.gsub!(/\[b\](.*?)\[\/b\]/mi, '*\1*')
    text.gsub!(/\[i\](.*?)\[\/i\]/mi, '/\1/')
    text.gsub!(/\[u\](.*?)\[\/u\]/mi, '_\1_')
    text.gsub!(/\[s\](.*?)\[\/s\]/mi, '-\1-')
    text.gsub!(/\[del\](.*?)\[\/del\]/mi, '-\1-')
    text.gsub!(/\[ins\](.*?)\[\/ins\]/mi, '+\1+')
    text.gsub!(/\[code\](.*?)\[\/code\]/mi, '\1')
    text.gsub!(/\[size=("|'|)([^\]]*)\1\](.*?)\[\/size\]/mi, '\3')
    text.gsub!(/\[color=("|'|)([^\]]*)\1\](.*?)\[\/color\]/mi, '\3')
    text.gsub!(/\[url\](.*?)\[\/ur;\]/mi, '\1')
    return text
  end

  def scan_for_refs
    return content ? content.scan(/>>(\d+)/).map {|m| m[0].to_i} : []
  end

  def self.generate (opts)
    board_id = opts[:board] || SiteSettings.first_or_create.sitewide_event_board
    post = Post.new(board: board_id, owner: opts[:user], content: opts[:content], post_type: opts[:type], reference: opts[:reference], pinned: opts[:pinned])
    post.save!
    board = Board.find_by_id(board_id)
    if board
      if post.post_type == YELLING || post.post_type == MAILING
        board.last_yell = post.id
      elsif post.is_event
        board.last_event = post.id
      else
        board.last_post = post.id
      end
      board.save!
      for ref in post.scan_for_refs
        reffed = Post.find_by_id(ref)
        if reffed and reffed.owner
          tu = BoardUser.get_by_ids(board.id, reffed.owner)
          tu.last_reply = post.id
          tu.save!
        end
      end
    end
  end

end
