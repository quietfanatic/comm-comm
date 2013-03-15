class MainController < ApplicationController

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
        @unconfirmed_users = User.where("is_confirmed = 'f' OR is_confirmed IS NULL").all
        @all_users = User.order('id').all
      end
    end
  end

  def about
    logged_in?
  end

  def mail
    logged_in do
      redirect_to '/main/board' and return unless @user.can_mail_posts != false
      @post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless @post
      @users = User.all
    end
  end

end
