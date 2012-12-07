class MainController < ApplicationController

  def topic
    redirect_to '/main/board'  # deprecation yay!
  end

  def board
    logged_in do
      @board = Board.find_by_id(params['board'])
      @posts = Post.where(board: @board ? @board.id : nil)
      @posts = @posts.order('id desc').limit(@board ? @board.ppp : 50).all
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
        board_user.updated_to = Post.last.id
        board_user.save!
      end
    end
  end

  def settings
    logged_in do
      if @user.can_edit_boards
        @boards = Board.order('"order", "id"').all
      end
      if @user.can_edit_users or @user.can_confirm_users
        @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL")
      end
    end
  end

  def about
    logged_in?
  end

  def update
    logged_in do
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
      @pinned_posts = @new_posts.select { |p|
        p.post_type == Post::PINNING
      }.map { |p|
        Post.find_by_id(p.reference)
      }
      if @board and @new_posts and @new_posts.length > 0
        board_user = BoardUser.get(@board, @user)
        board_user.updated_to = Post.last.id
        board_user.save!
      end
    end
  end

  def start_edit
    logged_in do
      @post = Post.find_by_id(params['id'])
    end
  end

  def mail
    logged_in do
      redirect_to '/main/board' and return unless @user.can_mail_posts != false
      @post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless @post
      @users = User.all
    end
  end

  def backlog
    logged_in do
      @board = Board.find_by_id(params['board'])
      if before = params["before"].to_i
        if @board
          @old_posts = Post.order('id desc').where(
            '"board" = :board AND "id" < :before',
            board: @board.id, before: before
          ).limit(@board.ppp).all
        else
          @old_posts = Post.order('id desc').where(
            '"board" IS NULL AND "id" < :before',
            before: before
          ).limit(50).all
        end
        @old_posts.reverse! if @old_posts
      end
    end
  end
end
