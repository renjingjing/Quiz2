class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :myidea
  validates :myidea_id, uniqueness: {scope: :user_id}

end
