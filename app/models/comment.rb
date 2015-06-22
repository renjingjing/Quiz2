class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :myidea

# the argument for has_many should always be plural
#has_many :comments, dependent: :destroy

validates :body, presence: true
end
