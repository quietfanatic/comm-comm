
class ConfigureController < ApplicationController

  def profile
    logged_in do
      editee = User.find_by_id(params['id'])
      if editee and (@user.can_edit_users or @user.id == editee.id)
        if params['email']
          editee.email = params['email']
        end
        if params['name']
          editee.visible_name = params['name']
        end
        if params['password'] && params['confirm_password'] && params['password'].match(/\S/)
          if params['password'] == params['confirm_password']
            editee.password = params['password']
          end
        end
        editee.save!
      end
      redirect_to '/main/settings?section=profile'
    end
  end

  def a_session
    logged_in do
      if params.has_key?('logout')
        if @user.can_edit_users or @user.id == sess.user_id
          sess = Session.find_by_id(params['logout'])
          sess.destroy if sess
        end
      end
      redirect_to '/main/settings?section=sessions'
    end
  end

  def confirm
    logged_in do
      if @user.can_confirm_users
        confirmee = User.find_by_id(params['id'])
        if confirmee and not confirmee.is_confirmed
          if params['do'] == 'confirm'
            confirmee.is_confirmed = true
            confirmee.save!
          elsif params['do'] == 'deny'
            confirmee.destroy
          end
        end
      end
      redirect_to '/main/settings?section=confirm'
    end
  end

  def appearance
    logged_in do
      redirect_to '/main/settings' and return unless @user.can_change_appearance
      settings = SiteSettings.first_or_create

      def empty_is_nil(val)
        return val && val =~ /\S/ ? val : nil
      end

      settings.logo_text = empty_is_nil params['logo_text']
      settings.background_gradient_top = empty_is_nil params['gradient_top']
      settings.background_gradient_bottom = empty_is_nil params['gradient_bottom']
      settings.background_image = empty_is_nil params['background_image']
      settings.navigation_text_color = empty_is_nil params['navigation_text_color']
      settings.about_us_html = empty_is_nil params['about_us_html']
      settings.save!
      Post.generate type: Post::APPEARANCE_CHANGING, user: @user.id
      redirect_to '/main/settings?section=appearance'
    end
  end

  def new_board
    logged_in do
      redirect_to '/main/settings' and return unless @user.can_edit_boards
      name = params['name']
      if name and name =~ /\S/
        board = Board.new(name: name, order: params['order'], ppp: params['ppp'])
        board.save!
        Post.generate(
          type: Post::BOARD_CREATION,
          board: board.id,
          reference: board.id,
          user: @user.id,
          content: board.name,
        )
        redirect_to '/main/board?board=' + board.id.to_s
      else
        redirect_to '/main/board'
      end
    end
  end

  def change_board
    logged_in do
      redirect_to '/main/settings?section=boards'
      return unless @user.can_edit_boards
      board = Board.find_by_id(params['id'])
      if board
        if params['do'] == 'change'
          name = params['name']
          if name and name =~ /\S/ and name != board.name
            oldname = board.name
            board.name = name
            Post.generate(
              type: Post::BOARD_RENAMING,
              board: board.id,
              reference: board.id,
              user: @user.id,
              content: oldname + "\n" + board.name
            )
          end
          order = params['order']
          if order and order != board.order
            board.order = order
            Post.generate(
              type: Post::BOARD_REORDERING,
              board: board.id,
              reference: board.id,
              user: @user.id,
              content: board.name
            )
          end
          ppp = params['ppp']
          if ppp and ppp != board.ppp
            board.ppp = ppp
          end
          board.save!
        elsif params['do'] == 'delete'
           # Deletion of boards is NYI
        end
      end
    end
  end

  def merge_boards
    logged_in do
      redirect_to '/main/settings?section=boards'
      return unless @user.can_edit_boards
      from = Board.find_by_id(params['from'].to_i)
      return unless from
      to = Board.find_by_id(params['to'].to_i)
      return unless to and from.id != to.id
      posts = Post.find_all_by_board(from.id)
      for p in posts
         # TODO: do this with real SQL to be much faster
        p.board = to.id
        p.save
      end
      event = Post.new(
        post_type: Post::BOARD_MERGING,
        board: to.id,
        reference: from.id,
        owner: @user.id,
         # Yes we're storing the ids of all the affected posts.
        content: from.name + "\n" + to.name + "\n" + posts.map{|p|p.id.to_s}.join("\n")
      )
      event.save!
      to.last_event = event.id
      to.last_post = [from.last_post || 0, to.last_post || 0].max
      to.last_yell = [from.last_yell || 0, to.last_yell || 0].max
      to.save!
       # Don't destroy from, in case we want to undo.
      from.visible = false
      from.save!
      settings = SiteSettings.first_or_create
      settings.last_merge_event = event.id
      settings.save!
    end
  end

  def undo_last_merge
    logged_in do
      redirect_to '/main/settings?section=boards'
      return unless @user.can_edit_boards
      settings = SiteSettings.first_or_create
      return unless settings.last_merge_event
      ev = Post.find_by_id(settings.last_merge_event)
      return unless ev and ev.post_type == Post::BOARD_MERGING
      from = Board.find_by_id(ev.board)
      to = Board.find_by_id(ev.reference)
      lines = ev.content.split("\n")
      posts = []
      for l in lines[2, lines.length - 2]
        p = Post.find_by_id(l.to_i)
        if p and p.board
          p.board = to.id
          p.save
          posts << p
        end
      end
      ev.board = to.id
      ev.save!
      event = Post.new(
        post_type: Post::BOARD_UNMERGING,
        board: to.id,
        reference: from.id,
        owner: @user.id,
        content: to.name + "\n" + from.name + "\n" + posts.map{|p|p.id.to_s}.join("\n")
      )
      event.save!
      to.last_event = event.id
      to.visible = true
      to.save!
      settings = SiteSettings.first_or_create
      settings.last_merge_event = nil
      settings.save!
    end
  end

  def default_boards
    logged_in do
      if @user.can_edit_boards
        settings = SiteSettings.first_or_create
        if Board.find_by_id(params['initial_board'].to_i)
          settings.initial_board = params['initial_board'].to_i
        end
        if Board.find_by_id(params['sitewide_event_board'].to_i)
          settings.sitewide_event_board = params['sitewide_event_board'].to_i
        end
        settings.save!
      end
      redirect_to '/main/settings?section=boards'
    end
  end

  def updating
    logged_in do
      redirect_to '/main/settings?section=updating'
      return unless @user.can_change_site_settings
      settings = SiteSettings.first_or_create
      x = params['min_update_interval']
      settings.min_update_interval = x if x
      x = params['max_update_interval']
      settings.max_update_interval = x if x
      settings.save!
    end
  end

  def mail
    logged_in do
      redirect_to '/main/settings?section=mail'
      return unless @user.can_change_site_settings
      settings = SiteSettings.first_or_create
      settings.enable_mail = params.has_key?('enable_mail')
      settings.smtp_server = params['smtp_server'] || nil
      settings.smtp_port = params['smtp_port'] || nil
      settings.smtp_auth = params['smtp_auth'] || nil
      settings.smtp_username = params['smtp_username'] || nil
      settings.smtp_password = params['smtp_password'] || nil
      settings.smtp_starttls_auto = params.has_key?('smtp_starttls_auto')
      settings.smtp_ssl_verify = params['smtp_ssl_verify'] || nil
      settings.mail_from = params['mail_from'] || nil
      settings.mail_subject_prefix = params['mail_subject_prefix'] || nil
      settings.send_test_to = params['send_test_to'] || nil
      settings.save!
      if params['do'] == 'send_test'
        PostOffice.test(@user, settings.send_test_to).deliver
      end
    end
  end

  def user
    logged_in do
      redirect_to '/main/settings?section=users'
      return unless @user.can_edit_users
      @editee = User.find_by_id(params['id'])
      return unless @editee
      settings = SiteSettings.first_or_create
      if params['do'] == 'change'
        @editee.visible_name = params['name'] if params.has_key?('name')
        @editee.email = params['email'] if params.has_key?('email')
        @editee.can_mail_posts = params.has_key?('can_mail_posts')
        @editee.can_change_appearance = params.has_key?('can_change_appearance')
        @editee.can_edit_boards = params.has_key?('can_edit_boards')
        @editee.can_confirm_users = params.has_key?('can_confirm_users')
        @editee.can_change_site_settings = params.has_key?('can_change_site_settings')
        @editee.can_edit_users = params.has_key?('can_edit_users')
        @editee.save!
        Post.generate type: Post::USER_EDITING, reference: @editee.id, user: @user.id
      elsif params['do'] == 'exile'
        @editee.exiled = true
        @editee.can_mail_posts = false
        @editee.can_change_appearance = false
        @editee.can_edit_boards = false
        @editee.can_confirm_users = false
        @editee.can_change_site_settings = false
        @editee.can_edit_users = false
        @editee.save!
        ss = Session.find_by_user_id(@editee.id)
        ss.destroy_all if ss
        Post.generate type: Post::EXILING, reference: @editee.id, user: @user.id
      elsif params['do'] == 'reinstate'
        @editee.exiled = false
        @editee.save!
        Post.generate type: Post::REINSTATION, reference: @editee.id, user: @user.id
      end
    end
  end
end
