class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:authenticate, :create, :delete_me, :update_field, :recover_password]
  before_filter :authenticate_user, :except => [:login, :authenticate, :create, :recover_password]
  
  def new
    render :layout => "users_menu"
  end

  def create
    available_user = User.find(params[:username])
    if available_user.blank?
      unless (params[:password] == params[:password_confirm])
        flash[:error] = "Unale to create user account. Password mismatch!!"
        redirect_to(users_login_path) and return if params[:from_login]
        redirect_to(users_new_user_path) and return
      end
      user = User.new
      user.username = params[:username]
      user.password_hash = params[:password]
      user.first_name = params[:first_name]
      user.last_name = params[:last_name]
      user.email = params[:email]
      if user.save
        flash[:notice] = "Your user account has been successfully created"
        redirect_to(users_login_path) and return if params[:from_login]
        redirect_to(users_new_user_path) and return
        redirect_to('/') and return
      else
        flash[:error] = "There was an error creating your account"
        redirect_to(users_login_path) and return if params[:from_login]
        redirect_to(users_new_user_path) and return
      end

    else
      flash[:error] = "Unable to create user. Username already exists"
      redirect_to(users_login_path) and return if params[:from_login]
      redirect_to(users_new_user_path) and return
    end
  end

  
  def login
    render :layout => false
  end

  def user_menu
    render :layout => "users_menu"
  end

  def authenticate
    @user = User.find(params[:username])
    unless @user.blank?
      if @user.password == params[:password]
        flash[:notice] = "Welcome #{params[:username]}"
        session[:current_user_id] = @user.id
        User.current_user = @user
        redirect_to ('/') and return
      else
        flash[:error] = 'Wrong username/password combination'
        redirect_to (users_login_path) and return
      end
    else
      flash[:error] = 'Wrong username/password combination'
      redirect_to (users_login_path) and return
    end
  end
  
  def logout
    session[:current_user_id] = nil
    User.current_user = nil
    flash[:notice] = 'You have been logged out.'
    redirect_to (users_login_path) and return
  end

  def users_menu

  end

  def new_user
    
  end

  def update_user
    user = User.find(params[:user_id])
    user.username = params[:username]
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.email = params[:email]
    if user.save
      flash[:notice] = "You have successfully updated user account"
      redirect_to users_edit_user_path and return
    else
      flash[:error] = "Unable to update user account."
      redirect_to users_edit_user_path, :user_id => params[:user_id] and return
    end
  end
  
  def edit_user
    unless params[:user_id].blank?
      @user = User.find(params[:user_id])
    end
    @active_users = User.by_active.key(true)
  end

  def delete_user
    @active_users = User.by_active.key(true)
  end

  def delete_me
    user = User.find(params[:username])
    user.active = false
    user.save
    render :text => true and return
  end

  def my_profile
    @user = User.find(session[:current_user_id])
  end

  def field_edit
    @user = User.find(session[:current_user_id])
  end

  def update_field
    user = User.find(session[:current_user_id])
    if (params[:field] == 'first_name')
      user.first_name = params[:first_name]
    end

    if (params[:field] == 'last_name')
      user.last_name = params[:last_name]
    end

    if (params[:field] == 'username')
      user.username = params[:username]
      existing_user = User.find(params[:username])
      unless existing_user.blank?
        flash[:error] = "Username already in use"
        redirect_to :action => "field_edit", :field => params[:field]
      end
    end

    if (params[:field] == 'email')
      user.email = params[:email]
    end
    
    if (params[:field] == 'password')
      if (params[:password].squish != params[:password_confirm].squish)
        flash[:error] = 'Password Mismatch'
        redirect_to :action => "field_edit", :field => params[:field] and return
      end
      user.password_hash = params[:password]
    end

    if user.save
      flash[:notice] = "You have succeffully edited your field"
      redirect_to :action => "my_profile"
    else
      flash[:error] = "Unable to save your changes"
      redirect_to :action => "field_edit", :field => params[:field]
    end
  end

  def recover_password
    email = params[:email]
    user = User.by_email.key(email).last
    first_name = user.first_name.capitalize rescue ''
    unless user.blank?
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      string = (0...5).map { o[rand(o.length)] }.join
      user.password_hash = string #new autogenerated password
      user.save
      RestClient.post "https://api:key-3ax6xnjp29jd6fds4gc373sgvjxteol0"\
        "@api.mailgun.net/v3/samples.mailgun.org/messages",
        :from => "Disease Surveillance Dashboard <mangochiman@gmail.com>",
        :to => "#{email}",
        :subject => "PASSWORD RECOVERY",
        :html => "Dear <i>#{first_name},</i><br />Your password has been recovered. Your new password is now <b>#{string}</b><br />Disease Surveillance Team\
      <br /><br />*<span style='font-size:8pt; font-style:italic; font-weight:bold;'>Please do not respond to this auto-generated email</span>*"
    end
    render :text => 'true' and return
  end

end
