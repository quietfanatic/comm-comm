class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :post_date, :topic, :pinned, :type, :reference
  validates :content, :presence => true
end
