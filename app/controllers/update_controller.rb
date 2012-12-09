class UpdateController < ApplicationController

  def update
    logged_in do
      @board = Board.find_by_id(params['board'])
      since = params['since'].to_i
      if since
        if @board
          @new_posts = Post.order('id').where(
            '"board" = :board AND "id" > :since',
            board: @board.id, since: since
          )
        else
          @new_posts = []  # I've had it with the UnBoard.
        end
      else
        @new_posts = []
      end
      @new_posts = [] unless @new_posts
      if @board and @new_posts and @new_posts.length > 0
        board_user = BoardUser.get(@board, @user)
        board_user.updated_to = Post.last.id
        board_user.save
      end
    end
  end

  def backlog
    logged_in do
      @board = Board.find_by_id(params['board'])
      if @board
        @old_posts = Post.order('id desc').where(
          '"board" = :board AND "id" < :before',
          board: @board.id, before: params['before']
        ).limit(@board.ppp).all
      else
        @old_posts = []
      end
    end
  end

  def start_edit
    logged_in do
      @post = Post.find_by_id(params['post'])
    end
  end
end
