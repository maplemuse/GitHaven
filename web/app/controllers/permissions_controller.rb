class PermissionsController < ApplicationController
  before_filter :require_login
  before_filter :require_authorization, :except => [:new, :create]

  # GET /permissions/new
  def new
    @repository = Repository.find(params[:repo])
    if @repository.user != @loggedinuser
        redirect_to(edit_repository_url(@repository))
        return
    end

    @users = User.find(:all)
    @permission = Permission.new
    @permission.repository = @repository

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  # POST /permissions
  def create
    @permission = Permission.new(params[:permission])
    return if !require_authorization

    @repository = @permission.repository
    @repository.permissions << @permission
    respond_to do |format|
      if @permission.save
        flash[:notice] = t('permissions.created',
                            :username => h(@permission.user.username),
                            :repositoryname => h(@permission.repository.name))
        format.html { redirect_to(edit_repository_url(@repository)) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
    rescue
        flash[:notice] = "error"
        redirect_to(edit_repository_url(@repository))
  end

  # GET /permissions/1/edit
  def edit
  end

  # PUT /permissions/1
  def update
    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        flash[:notice] = t('permissions.updated',
                            :username => h(@permission.user.username),
                            :repositoryname => h(@permission.repository.name))
        format.html { redirect_to(edit_repository_url(@permission.repository)) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  def destroy
    username = @permission.user.username
    @repository = @permission.repository
    @permission.destroy
    flash[:notice] = t('permissions.deleted',
                        :username => h(username),
                        :repositoryname => h(@repository.name))
    respond_to do |format|
      format.html { redirect_to(edit_repository_url(@repository)) }
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end

private
  def require_authorization
    @permission = Permission.find(params[:id]) if !@permission
    if @permission.repository.user != @loggedinuser
        redirect_to(edit_repository_url(@permission.repository))
        return false
    end
    return true
  end

end
