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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  before_filter :find_logged_in_user
  layout 'site'
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8c9f143783d5b174c81e7ae0066d30ea'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like 'password').
  filter_parameter_logging :password

  def index
    @repositories = Repository.find(:all)
    rescue
    flash[:notice] = "Installation not complete, run 'rake db:migrate'"
    @repositories = []
  end

protected
  def find_logged_in_user
    @loggedinuser = User.find(session[:user_id])
    if @loggedinuser.sshkeys.empty? && !flash[:notice]
        link = url_for(:controller => 'sshkeys', :action => 'new')
        flash[:notice] = t('sshkey.nosshkeyhint', :link => link)
    end
  rescue
    session[:user_id] = nil
    @loggedinuser = nil
  end

  def require_login
    if @loggedinuser == nil
        session[:original_uri] = request.request_uri
        flash[:notice] = t('user.accessdenied')
        redirect_to :controller => 'users', :action => 'login'
    end
  end

end
