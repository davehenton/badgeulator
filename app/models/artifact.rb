class Artifact < ActiveRecord::Base
  belongs_to :side
  has_many :properties

  default_scope { order(%q("order" asc, name)) } 

  accepts_nested_attributes_for :properties, reject_if: :all_blank, allow_destroy: true
end
