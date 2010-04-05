class LinksController < ApplicationController
  before_filter :require_login

  # GET /links/new
  # GET /links/new.xml
  def new
    repo = params[:repo];
    if !repo
        flash[:notice] = t('repository.notfound')
        redirect_to root_url
        return
    end

    @repository = Repository.find(params[:repo])
    return if !require_authorization

    @link = Link.new
    @link.repository = @repository

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # POST /links
  # POST /links.xml
  def create
    @link = Link.new(params[:link])

    @repository = @link.repository
    return if !require_authorization
    @repository.links << @link

    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to(edit_repository_url(@repository)) }
        format.xml  { render :xml => @link, :status => :created, :location => @links }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /links/1/edit
  def edit
    @link = Link.find(params[:id])
    @repository = @link.repository
    return if !require_authorization
  end

  # PUT /link/1
  # PUT /link/1.xml
  def update
    @link = Link.find(params[:id])
    @repository = @link.repository
    return if !require_authorization

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'Link was successfully updated.'
        format.html { redirect_to(edit_repository_url(@repository)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /link/1
  # DELETE /link/1.xml
  def destroy
    @link = Link.find(params[:id])
    @repository = @link.repository
    return if !require_authorization

    @link.destroy

    respond_to do |format|
      format.html { redirect_to(edit_repository_url(@repository)) }
      format.xml  { head :ok }
    end
  end

private
  def require_authorization
    if !@repository
        flash[:notice] = t('repository.notfound')
        redirect_to root_url
        return false
    end
    if @repository.user != @loggedinuser
        flash[:notice] = t('repository.notowner')
        redirect_to(edit_repository_url(@repository))
        return false
    end
    return true
  end
end
