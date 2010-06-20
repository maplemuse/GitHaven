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
                            :username => @permission.user.username,
                            :repositoryname => @permission.repository.name)
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
                            :username => @permission.user.username,
                            :repositoryname => @permission.repository.name)
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
                        :username => username,
                        :repositoryname => @repository.name)
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
