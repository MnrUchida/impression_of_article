# == Schema Information
#
# Table name: tag_groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  sort_order :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tag_groups_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class TagGroup < ApplicationRecord
  belongs_to :user, inverse_of: :tag_groups
  has_many :tag_group_tags, dependent: :destroy, inverse_of: :tag_group
  has_many :tags, through: :tag_group_tags, inverse_of: :tag_groups

  scope :by_user, ->(user_id) { where(user_id: user_id) }

  def add_tag(tag_id)
    tag = Tag.find(tag_id)
    TagGroupTag.where(user: self.user, tag_id: tag.id).destroy_all
    self.tag_group_tags.create!(tag_id: tag.id, user: self.user)
  end
end
