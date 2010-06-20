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

class TagsController < ApplicationController
  before_filter :require_login, :except => [:show]
  before_filter :require_authorization, :except => [:show, :new, :create, :destroy]

  # GET /tags
  # GET /tags.xml
  def show
    @tag = params[:tag]
    @tags = Tag.find(:all, :conditions => ['tag = ?', @tag])
    @repositories = []
    @tags.each { |tag| @repositories << tag.repository }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    repo = params[:repo];
    if !repo
        flash[:notice] = t('repository.notfound')
        redirect_to root_url
        return
    end

    @repository = Repository.find(params[:repo])
    return if !require_authorization

    @tag = Tag.new
    @tag.repository = @repository

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])
    @repository = @tag.repository
    return if !require_authorization

    @repository.tags << @tag

    respond_to do |format|
      if @tag.save
        flash[:notice] = t('tag.created',
                            :tag => @tag.tag,
                            :repositoryname => @repository.name)
        format.html { redirect_to(edit_repository_url(@repository)) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @repository = @tag.repository
    return if !require_authorization

    @tag.destroy

    respond_to do |format|
      flash[:notice] = t('tag.deleted',
                          :tag => @tag.tag,
                          :repositoryname => @repository.name)
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
