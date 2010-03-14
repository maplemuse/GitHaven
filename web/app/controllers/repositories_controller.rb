class RepositoriesController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :requires_authorization, :only => [:edit, :update, :destroy]

  # GET /repositories
  def index
    @repositories = Repository.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  def show
    return if !find_repository
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  def raw
    return if !find_repository

    send_data @tree.data,
            :type     => @tree.mime_type(),
            :filename => @tree.name,
            :disposition => 'inline'
  end

  def commits
    return if !find_repository
    @start_at = 0
    @start_at = params[:start_at].to_i if params[:start_at]
    if @repo
        @commits = @repo.commits(@branch, 20 + @start_at)
        @commits = @commits.slice(@start_at, 20);
    end
    respond_to do |format|
      format.html
      format.xml  { render :xml => @repository }
      format.atom { render :layout => false }
    end
  end

  def commit
    return if !find_repository
    @sha1 = params[:sha1]
    @commits = @repo.commits(@sha1, 1)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
    rescue
      redirect_to root_url
  end

  def archive
    return if !find_repository
    if !@repo
        flash[:notice] = t('repository.notfound')
        redirect_to(:controller => 'repositories', :user => @repository.user.username, :repo => @repository.name, :action => 'show')
        return
    end
    send_data(@repo.archive_tar_gz(@branch),
        :filename => @repository.user.username + "-" + @repository.name + "-" + @branch + ".tar.gz");
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # POST /repositories
  def create
    repository = Repository.new(params[:repository])
    @loggedinuser.repositories << repository

    permission = Permission.new
    permission.mode = 'ro'
    everyone = User.find_by_username(I18n.t('user.all'))
    permission.user_id = everyone.id
    repository.permissions << permission

    respond_to do |format|
      if @loggedinuser.save && repository.save && permission.save
        flash[:notice] = t('repository.created', :name => repository.name)
        format.html { redirect_to(:controller => 'repositories', :user => repository.user.username, :repo => repository.name, :action => 'show') }
        format.xml  { render :xml => repository, :status => :created, :location => repository }
      else
        @repository = repository
        format.html { render :action => 'new' }
        format.xml  { render :xml => repository.errors, :status => :unprocessable_entity }
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
        flash[:notice] = t('repository.updated', :name => @repository.name)
        format.html { redirect_to(:controller => 'repositories', :user => @repository.user.username, :repo => @repository.name, :action => 'show') }
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
    flash[:notice] = t('repository.deleted', :name => name)

    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'show', :user => @loggedinuser.username ) }
      format.xml  { head :ok }
    end
  end

private
  def find_path
    if @repo
        @commits = @repo.commits(@branch, 1)
        @joinedpath = ''
        @joinedpath = @path.join('/') if @path
        @tree = @repo.commits(@branch).first.tree
        @tree = @tree/@joinedpath if @path
        if !@tree
            @path = ""
            @joinedpath = ""
            @tree = @repo.commits(@branch).first.tree
        end
    end
  end

  def find_repository
    @path = params[:path] if params[:path]
    if params[:repo] && params[:user]
      owner = User.find_by_username(params[:user])
      @repository = Repository.find_by_name(params[:repo], :conditions => ['user_id = ?', owner.id])
    else
      @repository = Repository.find(params[:id])
    end
    @owner = @repository.user
    @host = request.host
    if !@repository.authorized(@loggedinuser)
      flash[:notice] = t('repository.accessdenied')
      redirect_to root_url
      return false
    end
    @branch = @repository.defaultbranch
    @branch = params[:branch] if params[:branch]
    @branch = 'master' if !@branch || @branch.empty?

    @repo = Grit::Repo.new(@repository.location())
    @branches = @repo.branches()
    @branches = @branches.sort_by { |a| a.name }

    # In the event that @branch doesn't exists first check
    # to see if the branch name has a / in it which would
    # cause it to be split into part of the path
    if (@branches.index(@branch) == nil)
        @tpath = @path
        @tpath.each { |p|
            @branch += '/' + p;
            @tpath.delete(p)
            if !(@branch.index(@branch) == nil)
                @path = @tpath
                break;
            end
        } if @path
    end
    # Then look for master and then just choose the first one
    if (@branches.index(@branch) == nil)
        if (@branches.index('master'))
            @branch = 'master'
        else
            @branch = @branches.first.name
        end
    end

    @tags = @repo.tags()
    @tags = @tags.sort_by { |a| a.name }

    find_path

    return (@tree != nil)
    rescue
    @branches = []
    @tags = []
    if !@repository || !@owner
      flash[:notice] = t('repository.notfound')
      redirect_to root_url
      return false
    end
    return true;
  end

  def requires_authorization
    return if !find_repository
    if @owner != @loggedinuser
        @repository = nil
        flash[:notice] = t('repository.notowner')
        redirect_to root_url
    end
  end

end
