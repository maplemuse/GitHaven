class SshkeysController < ApplicationController
  before_filter :require_login

  def new
    @sshkey = Sshkey.new
  end

  def edit
    @sshkey = Sshkey.find(params[:id])
  end

  def create
    @sshkey = Sshkey.new(params[:sshkey])
    @user.sshkeys << @sshkey

    respond_to do |format|
      if @user.save && @sshkey.save
        flash[:notice] = t('sshkey.created', :name => h(@sshkey.name))
        format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @user.username) }
        format.xml  { render :xml => @sshkey, :status => :created, :location => @sshkey }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @sshkey = Sshkey.find(params[:id])

    respond_to do |format|
      if @sshkey.update_attributes(params[:sshkey])
        flash[:notice] = t('sshkey.updated', :name => h(@sshkey.name))
        format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @user.username) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @sshkey = Sshkey.find(params[:id])
    name = @sshkey.name
    @sshkey.destroy
    flash[:notice] = t('sshkey.deleted', :name => h(name))
    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @loggedinuser.username) }
      format.xml  { head :ok }
    end
  end

end
