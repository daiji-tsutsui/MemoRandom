module UsersHelper
  def current_user
    @current_user ||= User.find_by(id: 1)
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def redirect_back_or(default)
    redirect_to request.referer || default
  end
end
