class SshkeysController < ApplicationController
  before_filter :require_login
  after_filter :update_authorizedkeys, :except => [:new, :edit]

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
      if @user.save
        flash[:notice] = t('sshkey.created')
        format.html { redirect_to(:controller => 'users', :action => 'show', :user => @user.username) }
        format.xml  { render :xml => @sshkey, :status => :created, :location => @sshkey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @sshkey = Sshkey.find(params[:id])

    respond_to do |format|
      if @sshkey.update_attributes(params[:sshkey])
        flash[:notice] = t('sshkey.updated')
        format.html { redirect_to(:controller => 'users', :action => 'show', :user => @user.username) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @sshkey = Sshkey.find(params[:id])
    @sshkey.destroy
    flash[:notice] = t('sshkey.deleted')
    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'show', :user => @user.username) }
      format.xml  { head :ok }
    end
  end

private
  def update_authorizedkeys
    config = Rails::Configuration.new
    location = config.root_path + '/../bin/gitforest-generateauthorizedkeys';
    system(location)
  end

end
