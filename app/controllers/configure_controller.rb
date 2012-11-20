
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
        editee.save!
      end
      redirect_to '/main/settings?section=profile'
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

  def new_board
    logged_in do
      redirect_to '/main/settings' and return unless @user.can_edit_boards
      name = params['name']
      if name and name =~ /\S/
        board = Board.new(name: name)
        board.save!
        event = Post.new(
          post_type: Post::BOARD_CREATION,
          board: board.id,
          reference: board.id,
          owner: @user.id,
          content: board.name
        )
        event.save!
        board.last_event = event.id
        board.save!
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
            event = Post.new(
              post_type: Post::BOARD_RENAMING,
              board: board.id,
              reference: board.id,
              owner: @user.id,
              content: oldname + "\n" + board.name
            )
            event.save!
            board.last_event = event.id
          end
          order = params['order']
          if order and order != board.order
            board.order = order
            event = Post.new(
              post_type: Post::BOARD_REORDERING,
              board: board.id,
              reference: board.id,
              owner: @user.id,
              content: board.name
            )
            event.save!
            board.last_event = event.id
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

  def mail
    logged_in do
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
      end
      redirect_to '/main/settings?section=mail'
    end
  end


  def test_mail
    logged_in do
      to = params['send_test_to']
      settings = SiteSettings.first_or_create
      settings.send_test_to = to
      settings.save!
      PostOffice.test(@user, to).deliver
      redirect_to '/main/settings?section=mail'
    end
  end
end
