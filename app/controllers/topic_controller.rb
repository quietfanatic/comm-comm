class TopicController < ApplicationController
  def new
    @name = params['name']
    if @name
      Topic.create(name: @name)
    end
    redirect_to '/main/settings'
  end
end
