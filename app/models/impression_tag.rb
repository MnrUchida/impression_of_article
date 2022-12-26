# == Schema Information
#
# Table name: impression_tags
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  impression_id :bigint           not null
#  tag_id        :bigint           not null
#
# Indexes
#
#  index_impression_tags_on_impression_id  (impression_id)
#  index_impression_tags_on_tag_id         (tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (impression_id => impressions.id)
#  fk_rails_...  (tag_id => tags.id)
#
class ImpressionTag < ApplicationRecord
  belongs_to :impression, inverse_of: :impression_tags
  belongs_to :tag, inverse_of: :impression_tags

  delegate :content, to: :tag, prefix: true
end
