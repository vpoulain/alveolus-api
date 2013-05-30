class WebappSerializer < ActiveModel::Serializer
  attributes :id,:caption,:title,:description,:average_rate,:image_url,:category_id,:nb_click_preview,  :facebook_id,:twitter_id, :gplus_id,:vimeo_id,:user_id, :nb_click_url,:nb_click_detail,:url, :validate, :category_id
  has_many :comments, :serializer => CommentSerializer
  has_many :tags
  has_one :category, :serializer => CategoryLazySerializer
  has_one :user, :serializer => UserLazySerializer

  def image_url
  	object.image_url(:medium)
  end
end
