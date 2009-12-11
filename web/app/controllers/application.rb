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
