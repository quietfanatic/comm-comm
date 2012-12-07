class PostController < ApplicationController
  def new
    logged_in do
      board = Board.find_by_id(params['board'])
      if params['content'] and params['content'] =~ /\S/
        if !Post.last or Post.last.content != params['content']
          @post = Post.new(content: params['content'], owner: @user.id, board: board ? board.id : nil )
          @post.save!
          if board
            board.last_post = @post.id
            board.save!
            for ref in @post.scan_for_refs
              @reffed = Post.find_by_id(ref)
              if @reffed and @reffed.owner
                tu = BoardUser.get_by_ids(board.id, @reffed.owner)
                tu.last_reply = @post.id
                tu.save!
              end
            end
          end
        end
      end
      redirect_to '/main/board' + (board ? "?board=#{board.id}" : '')
    end
  end
  def edit
    logged_in do
      old = Post.find_by_id(params['id'])
      if old and params['content'] and params['content'] =~ /\S/
        @post = Post.new(post_type: Post::EDIT, reference: old.id, content: params['content'], owner: @user.id, board: old.board, pinned: true)
        @post.save!
        old.pinned = false
        old.save!
      end
      redirect_to '/main/board' + (old.board ? "?board=#{old.board}" : '')
    end
  end

  def button
    logged_in do
      post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless post
      board = Board.find_by_id(post.board)
      case params['do']
      when 'pin'
        post.pinned = true
        post.save!
        event = Post.new(post_type: Post::PINNING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
        end
      when 'unpin'
        post.pinned = false
        post.save!
        event = Post.new(post_type: Post::UNPINNING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
        end
      when 'yell'
        post.yelled = true
        post.save!
        Rails.logger.warn post.yelled
        event = Post.new(post_type: Post::YELLING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_yell = event.id;
          board.save!
        end
      when 'unyell'
        post.yelled = false
        post.save!
        event = Post.new(post_type: Post::UNYELLING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
        end
      when 'hide'
        post.hidden = true
        post.save!
        event = Post.new(post_type: Post::HIDING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
        end
      when 'unhide'
        post.hidden = false
        post.save!
        event = Post.new(post_type: Post::UNHIDING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
        end
      when 'mail'
        redirect_to "/main/mail?id=#{post.id}" and return
      end
      redirect_to '/main/board' + (board ? "?board=#{board.id}" : '')
    end
  end
  def mail
    logged_in do
      post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless post and @user.can_mail_posts != false
      board = Board.find_by_id(post.board)
      recipients = params.keys.select { |k|
        k.match(/^\d+$/)
      }.map { |id|
        User.find_by_id(id)
      }
      Rails.logger.warn "#{recipients}"
      message = PostOffice.post(@user, post, recipients)
      message.deliver if message
      post.yelled = true
      post.save!
      event = Post.new(post_type: Post::MAILING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
      event.save!
      if board
        board.last_yell = event.id;
        board.save!
      end
      redirect_to '/main/board' + (board ? "?board=#{board.id}" : '')
    end
  end

end
