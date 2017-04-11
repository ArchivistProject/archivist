class MongoidBase
  include Mongoid::Document

  def id
    _id.to_s
  end

  def self.pluck_from(model_id, *to_pluck)
    where(id: model_id).pluck(*to_pluck).first
  end
end
