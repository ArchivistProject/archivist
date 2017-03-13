class User < MongoidBase
  include ActiveModel::SecurePassword

  before_create :generate_api_key

  field :name, type: String
  field :email, type: String
  field :password_digest, type: String
  field :api_key, type: String

  has_secure_password

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while User.where(api_key: api_key).size > 1
    self.save!
  end
end
