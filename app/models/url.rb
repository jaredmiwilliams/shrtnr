class Url < ActiveRecord::Base
  has_and_belongs_to_many :tags
end
