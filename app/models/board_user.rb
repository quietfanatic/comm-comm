class BoardUser < ActiveRecord::Base
  attr_accessible :board, :user_id, :updated_to, :last_reply

  def self.get_by_ids (tid, uid)
    return BoardUser.where(
      board: tid, user_id: uid
    ).first_or_create(board: tid, user_id: uid);
  end
  def self.get (board, user)
    return get_by_ids(board.id, user.id)
  end

  OFF = "indicator"
  EVENT = "indicator got_event"
  POST = "indicator got_post"
  YELL = "indicator got_yell"
  REPLY = "indicator got_reply"


  def self.indicators (user)
    indicators = []
    for tu in BoardUser.find_all_by_user_id(user.id)
      mytop = Board.find_by_id(tu.board)
      if mytop and tu.updated_to
        if (tu.last_reply and tu.last_reply > tu.updated_to)
          indicators[tu.board] = REPLY
        elsif (mytop.last_yell and mytop.last_yell > tu.updated_to)
          indicators[tu.board] = YELL
        elsif (mytop.last_post and mytop.last_post > tu.updated_to)
          indicators[tu.board] = POST
        elsif (mytop.last_event and mytop.last_event > tu.updated_to)
          indicators[tu.board] = EVENT
        else
          indicators[tu.board] = OFF
        end
      else
        indicators[tu.board] = OFF
      end
    end
    return indicators
  end


end
