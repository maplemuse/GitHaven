class UsersController < ApplicationController
  before_filter :require_login, :except => [:login, :show, :new, :create ]

  # GET /login
  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        url = nil if uri == 'logout'
        session[:original_uri] = nil
        redirect_to(uri || { :action => 'show', :user => user.username } )
      else
        flash.now[:notice] = t('user.invalid_user_or_password')
      end
    end
  end

  # GET /logout
  def logout
    session[:user_id] = nil
    flash[:notice] = t('user.loggedout')
    redirect_to(:action => 'login')
  end

  # GET /users
  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  def show
    @user = User.find(params[:id]) if params[:id]
    @user = User.find_by_username(params[:user]) if params[:user]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
    rescue
    redirect_to(:action => 'index' )
  end

  # GET /users/new
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # POST /users
  def create
    user = User.new(params[:user])
    user.username = params[:user][:username]
    if params[:sshkey] && !params[:sshkey].empty?
        sshkey = Sshkey.new()
        sshkey.name = 'Default'
        sshkey.key = params[:sshkey]
        user.sshkeys << sshkey
    end

    respond_to do |format|
      if user.save
        flash[:notice] = t('user.created', :username => h(user.username))
        session[:user_id] = user.id
        format.html { redirect_to( :controller => 'users', :action => 'show', :user => user.username)  }
        format.xml  { render :xml => user, :status => :created, :location => user }
      else
        @user = user
        format.html { render :action => 'new' }
        format.xml  { render :xml => user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = @loggedinuser
  end

  # PUT /users/1
  def update
    respond_to do |format|
      if @loggedinuser.update_attributes(params[:user])
        flash[:notice] = t('user.updated', :username => h(@loggedinuser.username))
        format.html { redirect_to( :controller => 'users', :action => 'show', :user => @loggedinuser.username)  }
        format.xml  { head :ok }
      else
        @user = @loggedinuser
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @loggedinuser.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    username = @loggedinuser.username
    @loggedinuser.destroy
    flash[:notice] = t('user.deleted', :username => h(username))
    respond_to do |format|
      format.html { redirect_to(root_url) }
      format.xml  { head :ok }
    end
  end
end
