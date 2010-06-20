#
#   Copyright (C) 2010 Benjamin C. Meyer <ben@meyerhome.net>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

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
    @loggedinuser.sshkeys << @sshkey

    respond_to do |format|
      if @loggedinuser.save
        flash[:notice] = t('sshkey.created', :name => @sshkey.name)
        format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @loggedinuser.username) }
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
        flash[:notice] = t('sshkey.updated', :name => @sshkey.name)
        format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @loggedinuser.username) }
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
    flash[:notice] = t('sshkey.deleted', :name => name)
    respond_to do |format|
      format.html { redirect_to(:controller => 'users', :action => 'edit', :user => @loggedinuser.username) }
      format.xml  { head :ok }
    end
  end

end
