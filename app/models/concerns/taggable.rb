module Taggable
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :tags
  end

  def tag_names
    tags.map(&:name)
  end

  def update_tags(new_tags)
    current_tags = tag_names # to reduce the number of times we hit mongo
    to_add    = new_tags - current_tags
    to_remove = current_tags - new_tags

    to_add.each { |t| tags << Tag.where(name: t, search_name: t.downcase).first_or_create! }
    to_remove.each { |t| tags.delete Tag.find_by(name: t) }
  end
end
