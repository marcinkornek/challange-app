class Opinion < ActiveRecord::Base
  belongs_to :opinionable, polymorphic: true

end
