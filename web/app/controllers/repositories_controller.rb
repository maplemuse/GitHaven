require 'grit'

class RepositoriesController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :requires_authorization, :only => [:edit, :update, :destroy]

  # GET /repositories
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

  # GET /repositories/1
  def show
    return if !find_repository

    @branch = 'master'
    if @repo
        @commits = @repo.commits('master', 1)
        @branch = params[:branch] if params[:branch]
        @path = params[:path] if params[:path]
        @joinedpath = ''
        @joinedpath = @path.join('/') if @path
        @tree = @repo.commits.last.tree
        @tree = @tree/@joinedpath if @path
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def commits
    return if !find_repository
    if @repo
        @commits = @repo.commits('master', 20)
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
    end
  end

  def commit
    return if !find_repository
    if !params[:sha1]
      redirect_to :action => 'index'
    end
    @sha1 = params[:sha1]
    @commits = @repo.commits(@sha1, 1)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
    @owner = @user
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # POST /repositories
  def create
    @repository = Repository.new(params[:repository])
    @user.repositories << @repository
    respond_to do |format|
      if @user.save && @repository.save
        flash[:notice] = t('repository.created', :name => h(@repository.name))
        format.html { redirect_to(@repository) }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /repositories/1/edit
  def edit
  end

  # PUT /repositories/1
  def update
    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:notice] = t('repository.updated', :name => h(@repository.name))
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  def destroy
    name = @repository.name
    @repository.destroy
    flash[:notice] = t('repository.deleted', :name => h(name))

    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'show', :user => @user.username ) }
      format.xml  { head :ok }
    end
  end

private
  def location
    config = Rails::Configuration.new
    location = config.root_path + '/../repos/' + @repository.user.username + '/' + @repository.name + '.git'
    return location
  end

  def find_repository
    if params[:repo]
      owner = User.find_by_username(params[:user])
      @repository = Repository.find_by_name(params[:repo], :conditions => ['user_id = ?', owner.id])
    else
      @repository = Repository.find(params[:id])
    end
    @owner = @repository.user
    if !@owner
      flash[:notice] = t('repository.notfound')
      redirect_to root_url
      return false
    end
    @host = request.host
    @repo = Grit::Repo.new(location())
    return true
    rescue
    return true
  end

  def requires_authorization
    return if !find_repository
    if @owner != @user
        flash[:notice] = t('repository.accessdenied')
        redirect_to root_url
    end
  end

end
