class Design < ActiveRecord::Base
  has_many :sides

  accepts_nested_attributes_for :sides, reject_if: :all_blank, allow_destroy: true
end
