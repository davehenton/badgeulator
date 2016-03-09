class Property < ActiveRecord::Base
  belongs_to :artifact

  default_scope { order('name') }
end
