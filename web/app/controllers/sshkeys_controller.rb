class SshkeysController < ApplicationController
  before_filter :find_user, :except => :index

  # GET /sshkeys
  # GET /sshkeys.xml
  def index
    @sshkeys = Sshkey.find(:all)
    if @sshkeys.count == 0
        flash[:notice] = 'No SSHkeys.'
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sshkeys }
    end
  end

  # GET /sshkeys/1
  # GET /sshkeys/1.xml
  def show
    @sshkey = Sshkey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sshkey }
    end
  end

  # GET /sshkeys/new
  # GET /sshkeys/new.xml
  def new
    @sshkey = Sshkey.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sshkey }
    end
  end

  # GET /sshkeys/1/edit
  def edit
    @sshkey = Sshkey.find(params[:id])
  end

  def update_authorizedkeys
    system("/home/ben/learningrails/pg/bin/gitforest-generateauthorizedkeys")
  end

  # POST /sshkeys
  # POST /sshkeys.xml
  def create
    @sshkey = Sshkey.new(params[:sshkey])
    @user.sshkeys << @sshkey

    respond_to do |format|
      if @user.save
        update_authorizedkeys
        flash[:notice] = 'SSHkey was successfully created.'
        format.html { redirect_to(@sshkey) }
        format.xml  { render :xml => @sshkey, :status => :created, :location => @sshkey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sshkeys/1
  # PUT /sshkeys/1.xml
  def update
    @sshkey = Sshkey.find(params[:id])

    respond_to do |format|
      if @sshkey.update_attributes(params[:sshkey])
        update_authorizedkeys
        flash[:notice] = 'SSHkey was successfully updated.'
        format.html { redirect_to(@sshkey) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sshkey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sshkeys/1
  # DELETE /sshkeys/1.xml
  def destroy
    @sshkey = Sshkey.find(params[:id])
    @sshkey.destroy
    update_authorizedkeys

    respond_to do |format|
      format.html { redirect_to(sshkeys_url) }
      format.xml  { head :ok }
    end
  end
end
