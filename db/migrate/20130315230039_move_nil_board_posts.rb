class MoveNilBoardPosts < ActiveRecord::Migration
  def up
    settings = SiteSettings.first_or_create
    Post.update_all({:board => settings.initial_board}, {:board => nil})
  end
end
