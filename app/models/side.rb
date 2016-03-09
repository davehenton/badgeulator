class Side < ActiveRecord::Base
  belongs_to :design
  has_many :artifacts

  accepts_nested_attributes_for :artifacts, reject_if: :all_blank, allow_destroy: true
end
