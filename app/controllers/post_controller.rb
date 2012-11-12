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

  def pin
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.pinned = true
        post.save!
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::PINNING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
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
  def unpin
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.pinned = false
        post.save!
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::UNPINNING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
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
  def yell
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.yelled = true
        post.save!
        Rails.logger.warn post.yelled
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::YELLING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_yell = event.id;
          board.save!
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
  def unyell
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.yelled = false
        post.save!
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::UNYELLING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
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
  def hide
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.hidden = true
        post.save!
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::HIDING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
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
  def unhide
    @user = User.logged_in(session)
    if @user
      post = Post.find_by_id(params['id'])
      if post
        post.hidden = false
        post.save!
        board = Board.find_by_id(post.board)
        event = Post.new(post_type: Post::UNHIDING, reference: post.id, owner: @user.id, board: board ? board.id : nil)
        event.save!
        if board
          board.last_event = event.id;
          board.save!
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

  def edit
  end

  def delete
  end

end
