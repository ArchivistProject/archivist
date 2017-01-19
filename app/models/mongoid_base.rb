class MongoidBase
  include Mongoid::Document

  def id
    _id.to_s
  end
end
