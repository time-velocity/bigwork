class UsersController < ApplicationController
  def new
  end
  def show
    @user = User.find(params[:id])
  end
  def new
    @user = User.new
  end
  def create
    params[:user]['admin'] = 'false'
    @user = User.new(params[:user].permit(:name,:email,:password,:password_confirmation)) 
    
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "激活邮件已经发往您的注册邮箱，请登录邮箱查看"
      redirect_to root_url
    else
      render 'new' 
    end
  end
end
