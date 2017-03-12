module Acl
  extend ActiveSupport::Concern

  included do
    field :owner, type: String

    scope :owned_by, ->(user) { where(owner: user.email) }
  end

  def is_owner?(user)
    owner == user.email
  end

  def be_seen?(user)
    is_owner? user
  end

  def be_edited?(user)
    is_owner? user
  end
end