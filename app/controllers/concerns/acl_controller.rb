module AclController
  extend ActiveSupport::Concern

  def verify(m,s)
    authed = m.send(s, @current_user)
    render json: { error: 'Unauthorized' }, status: 401 unless authed
  end
end
