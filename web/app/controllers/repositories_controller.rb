require 'grit'

class RepositoriesController < ApplicationController
  before_filter :require_login, :except => [:index, :show, :commits, :commit]

  def location
    return "/home/ben/learningrails/pg/repos/" + @repository.user.username + "/" + @repository.name + ".git"
  end

  # GET /repositories
  # GET /repositories.xml
  def index
    @repositories = Repository.find(:all)
    @user = User.find(session[:user_id])
    rescue
      @user = nil
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  def find_repository
    if params[:repo]
      @repository = Repository.find_by_name(params[:repo])
    else
      @repository = Repository.find(params[:id])
    end
    find_owner
    if !@owner
      flash[:notice] = "Sorry, but the repository does not exist."
      redirect_to :action => 'index'
      return false;
    end
    @host = request.host
    @repo = Grit::Repo.new(location())
    return true
    rescue
    flash[:notice] = "Sorry, but the repository is currently empty."
    return true
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    if !find_repository
      return
    end

    if @repo
        @commits = @repo.commits('master', 1)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def commits
    if !find_repository
      return
    end
    if @repo
        @commits = @repo.commits('master', 20)
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
    end
  end

  def commit
    if !find_repository
      return
    end
    if !params[:sha1]
      redirect_to :action => 'index'
    end
    @sha1 = params[:sha1]
    @commits = @repo.commits(@sha1, 1);
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository = Repository.new
    @owner = @user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
    find_owner
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
    find_owner
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
    find_owner
    if check_authorization == false
      return
    end
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'show', :user => @user.username ) }
      format.xml  { head :ok }
    end
  end

private
  def check_authorization
    if @owner != @user
        flash[:notice] = "You do not have permissions to modify this repository."
        redirect_to :action => 'index'
        return false
    end
    return true
  end

  def find_owner
    if @repository
      @owner = @repository.user
    end
  end

end
