class PostController < ApplicationController
  def new
    logged_in do
      if params['content'] and params['content'] =~ /\S/
        if !Post.last or Post.last.content != params['content']
          Post.generate(
            board: params['board'],
            user: @user.id,
            content: params['content']
          )
        end
      end
      redirect_to '/main/board' + (params['board'] ? "?board=#{params['board']}" : '')
    end
  end
  def edit
    logged_in do
      old = Post.find_by_id(params['id'])
      if old and params['content'] and params['content'] =~ /\S/
        Post.generate(
          type: Post::EDIT,
          reference: old.id,
          content: params['content'],
          user: @user.id,
          board: old.board,
          pinned: true
        )
        old.pinned = false
        old.save!
      end
      redirect_to '/main/board' + (old.board ? "?board=#{old.board}" : '')
    end
  end

  def button
    logged_in do
      post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless post
      board = Board.find_by_id(post.board)
       # Oh ruby you're silly
      @post = post
      @board = board
      def event (type)
        Post.generate(type: type, reference: @post.id, user: @user.id, board: @board ? @board.id : nil)
      end
      case params['do']
      when 'pin'
        post.pinned = true
        post.save!
        event Post::PINNING
      when 'unpin'
        post.pinned = false
        post.save!
        event Post::UNPINNING
      when 'yell'
        post.yelled = true
        post.save!
        event Post::YELLING
      when 'unyell'
        post.yelled = false
        post.save!
        event Post::UNYELLING
      when 'hide'
        post.hidden = true
        post.save!
        event Post::HIDING
      when 'unhide'
        post.hidden = false
        post.save!
        event Post::UNHIDING
      when 'mail'
        redirect_to "/main/mail?id=#{post.id}" and return
      end
      redirect_to '/main/board' + (board ? "?board=#{board.id}" : '')
    end
  end
  def mail
    logged_in do
      post = Post.find_by_id(params['id'])
      redirect_to '/main/board' and return unless post and @user.can_mail_posts != false
      board = Board.find_by_id(post.board)
      recipients = params.keys.select { |k|
        k.match(/^\d+$/)
      }.map { |id|
        User.find_by_id(id)
      }
      Rails.logger.warn "#{recipients}"
      message = PostOffice.post(@user, post, recipients)
      message.deliver if message
      post.yelled = true
      post.save!
      event = Post.generate(type: Post::MAILING, reference: post.id, user: @user.id, board: board ? board.id : nil)
      redirect_to '/main/board' + (board ? "?board=#{board.id}" : '')
    end
  end

end
