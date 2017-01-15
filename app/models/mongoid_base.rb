class MongoidBase
  include Mongoid::Document

  def id
    self._id.to_s
  end
end
