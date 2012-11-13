class PostController < ApplicationController
  def new
    @user = User.logged_in(session)
    if @user
      @board = Board.find_by_id(params['board'])
      if params['content'] and params['content'] =~ /\S/
        if !Post.last or Post.last.content != params['content']
          @post = Post.new(content: params['content'], owner: @user.id, board: @board ? @board.id : nil )
          @post.save!
          if @board
            @board.last_post = @post.id
            @board.save!
            for ref in @post.scan_for_refs
              @reffed = Post.find_by_id(ref)
              if @reffed and @reffed.owner
                tu = BoardUser.get_by_ids(@board.id, @reffed.owner)
                tu.last_reply = @post.id
                tu.save!
              end
            end
          end
        end
      end
      if @board
        redirect_to "/main/board?board=#{@board.id}"
      else
        redirect_to '/main/board'
      end
    else
      redirect_to '/login/entrance'
    end
  end

  def button
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
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
        end
        if board
          redirect_to "/main/board?board=#{board.id}"
        else
          redirect_to "/main/board"
        end
      else
        redirect_to "/main/board"
      end
    else
      redirect_to '/login/entrance'
    end
  end

end
