class Side < ActiveRecord::Base
  SIDES = [{ name: 'Front', value: 0 }, { name: 'Back', value: 1 }].freeze
  ORIENTATIONS = [{ name: 'Portrait', value: 0 }, { name: 'Landscape', value: 1 }].freeze

  belongs_to :design
  has_many :artifacts, dependent: :destroy

  accepts_nested_attributes_for :artifacts, reject_if: :all_blank, allow_destroy: true

  validates :order, presence: true
  validates :orientation, presence: true
  validates :margin, presence: true
  validates :width, presence: true
  validates :height, presence: true

  def name
    "#{design.name} (#{side_name})"
  end

  def side_name
    SIDES.detect{ |s| s[:value] == order }[:name] rescue ""
  end

  def orientation_name
    ORIENTATIONS.detect{ |s| s[:value] == orientation }[:name] rescue ""
  end

  def reorder_artifacts
    i = 0
    artifacts.each do |artifact|
      i = i + 10
      # skip validations and callbacks and stamping
      artifact.update_columns(order: i)
    end
  end
end
