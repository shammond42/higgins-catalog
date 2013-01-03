module AdminHelper
  def most_recent_sign_in(user)
    recent_sign_in_at = user.current_sign_in_at || user.last_sign_in_at

    if recent_sign_in_at
      return recent_sign_in_at.stamp('Jan 1, 2012')
    else
      return 'Never signed in'
    end
  end
end