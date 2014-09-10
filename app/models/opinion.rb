class Opinion < ActiveRecord::Base
  belongs_to :opinionable, polymorphic: true

  validates :opinionable_id, presence: true
  validates :opinionable_type, presence: true

end
