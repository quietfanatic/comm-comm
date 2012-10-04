class Post < ActiveRecord::Base
  attr_accessible :content, :owner, :post_date
end
