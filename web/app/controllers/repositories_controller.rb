class RepositoriesController < ApplicationController
  before_filter :find_user, :except => :index

  # GET /repositories
  # GET /repositories.xml
  def index
    @repositories = Repository.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    @repository = Repository.find(params[:id])
    @owner = User.find(@repository.user_id)
    @host = "meyerhome.net"

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
    if !check_authorization
      return
    end
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @repository = Repository.new(params[:repository])
    @user.addRepository(@repository)
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Repository was successfully created.'
        format.html { redirect_to(@repository) }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository = Repository.find(params[:id])
    if !check_authorization
      return
    end

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:notice] = 'Repository was successfully updated.'
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository = Repository.find(params[:id])
    if !check_authorization
      return
    end
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end

private
  def check_authorization
    @owner = User.find(@repository.user_id)
    if @owner != @user
        flash[:notice] = "You do not have permissions to modify this repository."
        redirect_to :action => 'index'
        return false
    end
  rescue
    logger.error("Unable to find repository")
    redirect_to :action => 'index'
    return true
  end

  def find_user
    @user = User.find(session[:user_id])
  rescue
    logger.error("This action requires that you be logged in.")
    flash[:notice] = "Not logged in."
    @user = nil
    redirect_to :controller => 'users', :action => 'login'
  end


end
