# == Schema Information
#
# Table name: mastodon_data_linkages
#
#  id         :bigint           not null, primary key
#  site       :string           not null
#  token      :string(512)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_mastodon_data_linkages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class MastodonDataLinkage < ApplicationRecord
  encrypts :token

  belongs_to :user, inverse_of: :mastodon_data_linkage
end
