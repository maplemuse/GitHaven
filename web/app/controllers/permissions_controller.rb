class PermissionsController < ApplicationController
  before_filter :require_login

  # GET /permissions/new
  # GET /permissions/new.xml
  def new
    @repository = Repository.find(params[:repo])
    @permission = Permission.new
    @permission.repository = @repository

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @permission }
    end
  end

  # GET /permissions/1/edit
  def edit
    @permission = Permission.find(params[:id])
  end

  # POST /permissions
  # POST /permissions.xml
  def create
    @permission = Permission.new(params[:permission])
    @repository = @permission.repository
    @permission.user_id = User.find_by_username(params[:user]).id
    @repository.permissions << @permission

    respond_to do |format|
      if @repository.save && @permission.save
        flash[:notice] = 'Permission was successfully created.'
        format.html { redirect_to(@permission) }
        format.xml  { render :xml => @permission, :status => :created, :location => @permission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /permissions/1
  # PUT /permissions/1.xml
  def update
    @permission = Permission.find(params[:id])

    respond_to do |format|
      if @permission.update_attributes(params[:permission])
        flash[:notice] = 'Permission was successfully updated.'
        format.html { redirect_to(@permission) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @permission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.xml
  def destroy
    @permission = Permission.find(params[:id])
    @permission.destroy

    respond_to do |format|
      format.html { redirect_to(permissions_url) }
      format.xml  { head :ok }
    end
  end
end
