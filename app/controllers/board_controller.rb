class BoardController < ApplicationController
  def new
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_boards
        name = params['name']
        if name and name =~ /\S/
          board = Board.new(name: name)
          event = Post.new(
            post_type: Post::BOARD_CREATION,
            board: board.id,
            reference: board.id,
            owner: @current_user.id,
            content: board.name
          )
          event.save!
          board.last_event = event.id
          board.save!
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
  def edit
    @current_user = User.logged_in(session)
    if @current_user
      if @current_user.is_confirmed and @current_user.can_edit_boards
        board = Board.find_by_id(params['id'])
        if board
          if params['do'] == 'change'
            name = params['name']
            if name and name =~ /\S/ and name != board.name
              oldname = board.name
              board.name = name
              event = Post.new(
                post_type: Post::BOARD_RENAMING,
                board: board.id,
                reference: board.id,
                owner: @current_user.id,
                content: oldname + "\n" + board.name
              )
              event.save!
              board.last_event = event.id
              board.save!
            end
            order = params['order']
            if order and order != board.order
              board.order = order
              event = Post.new(
                post_type: Post::BOARD_REORDERING,
                board: board.id,
                reference: board.id,
                owner: @current_user.id,
                content: board.name
              )
              event.save!
              board.last_event = event.id
              board.save!
            end
          elsif params['do'] == 'delete'
             # Deletion of boards is NYI
          end
        end
      end
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
end
