class Side < ActiveRecord::Base
  belongs_to :design
  has_many :artifacts
end
