class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def users_access
    @user = User.find(2)
    unless current_user == @user
      flash[:danger] = 'ユーザ画面を閲覧・編集する権限がありません。'
      redirect_to root_url
    end
  end
end
