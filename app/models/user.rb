# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  consumed_timestep      :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  otp_required_for_login :boolean
#  otp_secret             :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("admin"), not null
#  show_name              :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  devise :two_factor_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :recoverable, :validatable

  enum role: { admin: 0, writer: 1 }
  has_many :impressions, dependent: :destroy, inverse_of: :user
  has_many :tag_groups, dependent: :destroy, inverse_of: :user
  has_many :tag_group_tags, dependent: :destroy, inverse_of: :user

  before_create :set_otp_secret

  scope :only_show_name, -> { where(show_name: true) }
  scope :name_like, ->(name) { where("name ILIKE :name", name: "%#{name}%") }

  def enable_admin?
    admin? && otp_required_for_login?
  end

  def show_name?
    !!show_name
  end

  private def set_otp_secret
    self.otp_secret = User.generate_otp_secret
  end
end
