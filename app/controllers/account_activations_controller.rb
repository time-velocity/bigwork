class AccountActivationsController < ApplicationController
    def edit
        user = User.find_by(email: params[:email])
        if user && !user.activated? && user.user_authenticated?(:activation, params[:id])
            user.update_attribute(:activated,    true)
            user.update_attribute(:activated_at, Time.zone.now)
            log_in user
            flash[:success] = "账户已激活！"
            redirect_to root_url
        else
            flash[:danger] = "无效的激活链接"
            redirect_to root_url
        end 
    end
end
