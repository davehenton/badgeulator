class Artifact < ActiveRecord::Base
  belongs_to :side
  has_many :properties
end
