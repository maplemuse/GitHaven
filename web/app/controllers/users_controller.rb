class UsersController < ApplicationController
  def login
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:username], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => 'show', :id => user.id } )
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => 'login')
  end


  # GET /users
  # GET /users.xml
  def index
    @users = User.find(:all, :order => :name)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def find_username_arg
    if params[:id]
        @user = User.find(params[:id])
    else
        @user = User.find_by_username(params[:user])
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    find_username_arg
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    session_user = User.find(session[:user_id])
    if !session_user
        redirect_to(:action => 'login')
        return
    end
    @user = session_user
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    if !params[:sshkey].empty?
        @sshkey = Sshkey.new()
        @sshkey.name = 'Default'
        @sshkey.key = params[:sshkey]
        @user.sshkeys << @sshkey
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = "User h(#{@user.username}) was successfully created."
        format.html { redirect_to(:action => 'login') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    find_username_arg

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Successfully updated user #{@user.username}."
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    find_username_arg

    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
