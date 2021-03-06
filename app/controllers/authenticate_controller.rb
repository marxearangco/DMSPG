class AuthenticateController < ApplicationController
  
  before_action :confirm_logged_in, :except =>[:login, :logout, :attempt_login]

  def confirm_logged_in
  	session[:username]=nil
  end

  def login
    render layout: 'loginlayout'
  end

  def logout
  	session.clear
  	redirect_to(:action=>'login')
  end

  def attempt_login
    user = Session.find_by(:userName=>params[:user])
    if user
      if params[:password]==user.passWord
        session[:username]=user.userName
        session[:role] = user.privilege
        acct = Employee.find_by(:idEmp=> user.idEmp)
        if acct
        	session[:acctname] = acct.fName + ' ' + acct.midInit + '. ' + acct.lName 
        else
          session[:acctname] = 'Logout'
        end
        redirect_to main_index_path
      else
        flash[:notice] = 'Invalid Username/password'
        redirect_to(:action=>'login')
      end
    else
      flash[:notice] = 'Sign in or sign up first.'
      redirect_to(:action=>'login')
    end
  end

end
