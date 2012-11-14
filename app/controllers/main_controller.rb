class MainController < ApplicationController

  PPP = 50  # Posts per page
  def topic
    redirect_to '/main/board'  # deprecation yay!
  end
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
  def change_settings
    @user = User.logged_in(session)
    if @user
      if @user.can_change_site_settings
        settings = SiteSettings.first_or_create
        settings.enable_mail = params.has_key?('enable_mail')
        settings.smtp_server = params['smtp_server'] || ''
        settings.smtp_port = params['smtp_port'] || ''
        settings.smtp_auth = params['smtp_auth'] || ''
        settings.smtp_username = params['smtp_username'] || ''
        settings.smtp_password = params['smtp_password'] || ''
        settings.smtp_starttls_auto = params.has_key?('smtp_starttls_auto')
        settings.smtp_ssl_verify = params['smtp_ssl_verify'] || ''
        settings.save!
        redirect_to '/main/settings'
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
      @pinned_posts = @new_posts.select { |p|
        p.post_type == Post::PINNING
      }.map { |p|
        Post.find_by_id(p.reference)
      }
      if @board and @new_posts and @new_posts.length > 0
        board_user = BoardUser.get(@board, @user)
        board_user.updated_to = @new_posts.last.id
        board_user.save!
      end
    else
      redirect_to '/login/entrance'
    end
  end
  def test_mail
    @user = User.logged_in(session)
    if @user
      to = params['send_test_to']
      settings = SiteSettings.first_or_create
      settings.send_test_to = to
      settings.save!
      PostOffice.test(@user, to).deliver
      redirect_to '/main/settings'
    else
      redirect_to '/login/entrance'
    end
  end
  def mail
    @user = User.logged_in(session)
    if @user
      @post = Post.find_by_id(params['id'])
      if @post
        @board = 
        if @user.can_mail_posts == nil || @user.can_mail_posts and params['id']
          if @post
            @users = User.all
          else
            redirect_to '/main/board'
          end
        end
      else
        redirect_to '/main/board'
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
