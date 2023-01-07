# == Schema Information
#
# Table name: tag_group_tags
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tag_group_id :bigint           not null
#  tag_id       :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_tag_group_tags_on_tag_group_id  (tag_group_id)
#  index_tag_group_tags_on_tag_id        (tag_id)
#  index_tag_group_tags_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (tag_group_id => tag_groups.id)
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
class TagGroupTag < ApplicationRecord
  belongs_to :user, inverse_of: :tag_group_tags
  belongs_to :tag_group, inverse_of: :tag_group_tags
  belongs_to :tag, inverse_of: :tag_group_tags
end
