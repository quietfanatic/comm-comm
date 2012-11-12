class MainController < ApplicationController

  PPP = 50  # Posts per page

  def board
    @user = User.logged_in(session)
    if @user
      @board = Board.find_by_id(params['board'])
      @posts = Post.where(board: @board ? @board.id : nil)
      @posts = @posts.order('id desc').limit(PPP).all
      @posts = @posts.reverse if @posts

      if @board
        @pinned = Post.order(:id).where(
          board: @board.id, pinned: true
        )
      else
        @pinned = Post.order(:id).where(
          board: nil, pinned: true
        )
      end
      if @board and @posts and @posts.length > 0
        board_user = BoardUser.get(@board, @user)
        board_user.updated_to = @posts.last.id
        board_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
  end

  def settings
    @user = User.logged_in(session)
    if @user
      if @user.can_edit_boards
        @boards = Board.order('"order", "id"').all
      end
      if @user.can_edit_users or @user.can_confirm_users
        @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL")
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def update
    @user = User.logged_in(session)
    if @user
      @board = Board.find_by_id(params['board'])
      if since = params["since"].to_i
        if @board
          @new_posts = Post.order(:id).where(
            '"board" = :board AND "id" > :since',
            board: @board.id, since: since
          )
        else
          @new_posts = Post.order(:id).where(
            '"board" IS NULL AND "id" > :since',
            since: since
          )
        end
      else
        @new_posts = []
      end
      if @board and @new_posts and @new_posts.length > 0
        board_user = BoardUser.get(@board, @user)
        board_user.updated_to = @new_posts.last.id
        board_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def backlog
    @user = User.logged_in(session)
    if @user
      @board = Board.find_by_id(params['board'])
      if before = params["before"].to_i
        if @board
          @old_posts = Post.order('id desc').where(
            '"board" = :board AND "id" < :before',
            board: @board.id, before: before
          ).limit(PPP).all
        else
          @old_posts = Post.order('id desc').where(
            '"board" IS NULL AND "id" < :before',
            before: before
          ).limit(PPP).all
        end
        @old_posts.reverse! if @old_posts
      end
    else
      redirect_to '/login/entrance'
    end
  end
end
