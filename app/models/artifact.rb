class Artifact < ActiveRecord::Base
  belongs_to :side
  has_many :properties

  has_attached_file :logo

  default_scope { order(%q(side_id asc, "order" asc, name asc)) } 

  accepts_nested_attributes_for :properties, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :order, presence: true
  # only image types that prawn can handle
  validates_attachment :logo, content_type: { content_type: ["image/jpeg", "image/png"] }

  after_save :reorder
  after_destroy :reorder

  def reorder
    side.reorder_artifacts
  end
end
