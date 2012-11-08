class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :post_date, :topic, :pinned
  validates :content, :presence => true
end
