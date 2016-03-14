class Property < ActiveRecord::Base
  belongs_to :artifact

  default_scope { order( { artifact_id: :asc, name: :asc } ) }

  validates :name, presence: true
  
end
