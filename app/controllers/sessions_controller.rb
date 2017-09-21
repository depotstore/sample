class SessionsController < ApplicationController
  def new
    # debugger
  end

  def create
    # @user should be instance variable because of assign()
    @user = User.find_by(email: params[:sessions][:email].downcase)
    if @user && @user.authenticate(params[:sessions][:password])
      if @user.activated?
        log_in @user
        params[:sessions][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = 'Account not activated.'
        message += 'Check your email for the activation link.'
        flash.now[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end

  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
