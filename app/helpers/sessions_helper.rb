module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def is_admin?
      if current_user.nil?
        false
      else
        current_user[:admin]
      end
  end

  # 点击log_out,安全退出.只关闭浏览器时会保存cookie,安全退出后就没有了
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
      if session[:user_id]
        @current_user||= User.find_by(id: session[:user_id])
      elsif cookies.signed[:user_id]
        user = User.find_by(id: cookies.signed[:user_id])
        if user && user.user_authenticated?(:remember, cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  

end
