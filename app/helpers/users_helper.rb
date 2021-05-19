module UsersHelper
  def current_user
    @current_user ||= User.find_by(id: 1)
  end

  def logged_in?
    current_user.present?
  end
end
